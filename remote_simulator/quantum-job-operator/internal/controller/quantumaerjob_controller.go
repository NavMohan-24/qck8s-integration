/*
Copyright 2025.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

package controller

import (
	"context"
	"time"

	"k8s.io/apimachinery/pkg/runtime"
	ctrl "sigs.k8s.io/controller-runtime"
	"sigs.k8s.io/controller-runtime/pkg/client"
	logf "sigs.k8s.io/controller-runtime/pkg/log"

	aerjobv2 "quantum/Aerjob/api/v2"
)

// QuantumAerJobReconciler reconciles a QuantumAerJob object
type QuantumAerJobReconciler struct {
	client.Client
	Scheme *runtime.Scheme
}

// +kubebuilder:rbac:groups=aerjob.nav.io,resources=quantumaerjobs,verbs=get;list;watch;create;update;patch;delete
// +kubebuilder:rbac:groups=aerjob.nav.io,resources=quantumaerjobs/status,verbs=get;update;patch
// +kubebuilder:rbac:groups=aerjob.nav.io,resources=quantumaerjobs/finalizers,verbs=update
// +kubebuilder:rbac:groups=core,resources=pods,verbs=get;list;watch;create;delete
// +kubebuilder:rbac:groups=core,resources=serviceaccounts,verbs=get;list;watch

// Reconcile is part of the main kubernetes reconciliation loop which aims to
// move the current state of the cluster closer to the desired state.
func (r *QuantumAerJobReconciler) Reconcile(ctx context.Context, req ctrl.Request) (ctrl.Result, error) {
	log := logf.FromContext(ctx)

	job := &aerjobv2.QuantumAerJob{}

	// Fetch job using Name.
	if err := r.Get(ctx,req.NamespacedName,job); err != nil{
		log.Info("Job is deleted since last reconcile")
		return ctrl.Result{}, client.IgnoreNotFound(err)
	}

	log.Info("Reconciling Job", "name", job.Name, "phase", job.Status.JobStatus)
	
	// handle timeout of job
	if job.Status.StartTime != nil && job.Spec.Timeout > 0 {

		elapsed := time.Since(job.Status.StartTime.Time)
		timeout := time.Duration(job.Spec.Timeout)*time.Second

		if elapsed > timeout && job.Status.JobStatus != aerjobv2.Completed && 
			job.Status.JobStatus != aerjobv2.Failed {
				log.Info("Job timeout exceeded", "elapsed", elapsed, "timeout", timeout)
				return r.handleTimeout(ctx, job)
		}
	}

	switch job.Status.JobStatus{

		case "":
			return r.handleNewJob(ctx, job)
		
		case aerjobv2.Pending:
			return r.handlePendingJob(ctx,job)
		
		case aerjobv2.Progress:
			return r.handleRunningJob(ctx, job)
		
		case aerjobv2.Completed:
			return r.handleCompletedJob(ctx, job)
		
		case aerjobv2.Failed:
			return r.handleFailedJob(ctx, job)
			
	}
	return ctrl.Result{}, nil
}

// SetupWithManager sets up the controller with the Manager.
func (r *QuantumAerJobReconciler) SetupWithManager(mgr ctrl.Manager) error {
	return ctrl.NewControllerManagedBy(mgr).
		For(&aerjobv2.QuantumAerJob{}).
		Named("quantumaerjob").
		Complete(r)
}
