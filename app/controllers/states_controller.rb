class StatesController < ApplicationController
  def index # Display all states
    render json: State.all, status: :ok
  end

  def create # Create a new state
    Rails.logger.info "Creating new state with params #{params.to_json}"
    state = State.create(state_params)
    render json: state, status: :ok
  end

  def show # Display a specific state
    state_code = params[:id]
    state = State.first(state_code: state_code)
    render json: state, status: :ok
  end

  def update # Update a specific state
    state_code = params[:id]
    Rails.logger.info "Updating state #{state_code} with params #{params.to_json}"
    state = State.where(state_code: state_code).update(
      state_name: params[:state_name]
    )
    render json: state, status: :ok
  end

  def destroy # Delete a specific state
    state_code = params[:id]
    Rails.logger.warn "Deleting state #{state_code}"
    State.where(state_code: state_code).delete
  end

  private

  def state_params
    params.permit(:state_code, :state_name)
  end
end
