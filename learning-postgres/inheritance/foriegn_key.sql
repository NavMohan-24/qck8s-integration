--- order matters. Drop child and then parent.
DROP TABLE IF EXISTS electric_specs CASCADE;
DROP TABLE IF EXISTS vehicles CASCADE;

--- create parent
CREATE TABLE vehicles(
    vin serial PRIMARY KEY,
    manufacturer text
);

--- create child
CREATE TABLE electric_specs(
    vin int PRIMARY KEY REFERENCES vehicles(vin),
    battery_capacity int
);

--- insert data
--- first: create the vehicle
INSERT INTO vehicles (manufacturer) 
VALUES ('Tesla');

--- second: Add specs
INSERT INTO electric_specs (vin,battery_capacity) 
VALUES (1, 1000);

SELECT 'Query Parent (Vehicles)' AS label;
SELECT * FROM vehicles;

SELECT 'Query Child (electric_cars)' AS label;
SELECT * FROM electric_specs; 

SELECT * FROM vehicles 
JOIN electric_specs ON vehicles.vin = electric_specs.vin;

