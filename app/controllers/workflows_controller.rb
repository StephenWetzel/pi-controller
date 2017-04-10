class WorkflowsController < ApplicationController
  def index # Display all workflows
    render json: Workflow.all, status: :ok
  end

  def create # Create a new workflow
    Rails.logger.info "Creating new workflow with params #{params.to_json}"
    workflow = Workflow.create(workflow_params)
    render json: workflow, status: :ok
  end

  def show # Display a specific workflow
    workflow_id = params[:id]
    workflow = Workflow.first(workflow_id: workflow_id)
    render json: workflow, status: :ok
  end

  def update # Update a specific workflow
    workflow_id = params[:id]
    Rails.logger.info "Updating workflow #{workflow_id} with params #{params.to_json}"
    workflow = Workflow.where(workflow_id: workflow_id).update(
      workflow_name: params[:workflow_name],
      from_state: params[:from_state],
      to_state: params[:to_state],
      event_code: params[:event_code]
    )
    render json: workflow, status: :ok
  end

  def destroy # Delete a specific workflow
    workflow_id = params[:id]
    Rails.logger.warn "Deleting workflow #{workflow_id}"
    Workflow.where(workflow_id: workflow_id).delete
  end

  private

  def workflow_params
    params.permit(:workflow_id, :workflow_name, :from_state, :to_state, :event_code)
  end
end
