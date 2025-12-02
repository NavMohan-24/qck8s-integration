import requests
import json
import io
import base64
import os

from flask import Flask, request, Response, jsonify
from qiskit import QuantumCircuit, generate_preset_pass_manager,qpy
from qiskit_ibm_runtime.utils import RuntimeEncoder, RuntimeDecoder
from qiskit_ibm_runtime import QiskitRuntimeService


app = Flask(__name__)


simulator_url = os.getenv('SIMULATOR_SERVICE_URL', 
                'http://aer-simulator-service:5001')

IBM_API_KEY = os.getenv('IBM_API_KEY')
IBM_INSTANCE = os.getenv('IBM_INSTANCE')  

print("Initializing Transpiler Service ...")

@app.route("/health")
def health():
    return jsonify({"status" : "healthy", "service" : "transpiler"})

@app.route("/transpile", methods=["POST"])
def transpile():

    data = request.get_json()
    # decode the circuit
    circuits_b64 = data.get('circuits_qpy')
    shots = data.get("shots", 1024)
    backend_name = data.get("backend", "ibm_torino")

    if not circuits_b64:
        return jsonify({"error": "No circuits provided"}), 400
    
    # deserialize circuits
    circuits_bytes = base64.b64decode(circuits_b64)
    with io.BytesIO(circuits_bytes) as fptr:
        circuits = qpy.load(fptr)

    # initialize backend target
    service = QiskitRuntimeService(
        channel="ibm_quantum_platform",
        token = IBM_API_KEY,
        instance= IBM_INSTANCE)
    target = service.backend(name = backend_name).target

    # transpile circuit
    pm = generate_preset_pass_manager(optimization_level=3, target=target)
    isa_circuits = pm.run(circuits)

    # serialize the circuit
    with io.BytesIO() as fptr:
        qpy.dump(isa_circuits, fptr)
        isa_circuit_bytes = fptr.getvalue()
        isa_circuit_b64 = base64.b64encode(isa_circuit_bytes).decode("utf-8")

    try: 
        response = requests.post(
            f"{simulator_url}/execute",
            json = {
                "isa_circuits_b64" : isa_circuit_b64,
                "shots" : shots,
                "backend_name" : backend_name
            },
            timeout=300)

        if response.status_code == 200:
            print('simulation is complete ...')
            return jsonify(response.json())
        
        else:
            return jsonify({"error": f"Simulator failed: {response.text}"}), 500
        
    except Exception as e:
        import traceback
        return jsonify({
            "error": str(e),
            "traceback": traceback.format_exc()
        }), 500

if __name__ == '__main__':
    print("Starting Transpiler Service on port 5002...")
    app.run(host='0.0.0.0', port=5002)    

