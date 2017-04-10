class EventsController < ApplicationController
  def index # Display all events
    render json: Event.all, status: :ok
  end

  def create # Create a new event
    Rails.logger.info "Creating new event with params #{params.to_json}"
    event = Event.create(event_params)
    render json: event, status: :ok
  end

  def show # Display a specific event
    event_code = params[:id]
    event = Event.first(event_code: event_code)
    render json: event, status: :ok
  end

  def update # Update a specific event
    event_code = params[:id]
    Rails.logger.info "Updating event #{event_code} with params #{params.to_json}"
    event = Event.where(event_code: event_code).update(
      event_code: params[:event_code],
      event_name: params[:event_name]
    )
    render json: event, status: :ok
  end

  def destroy # Delete a specific event
    event_code = params[:id]
    Rails.logger.warn "Deleting event #{event_code}"
    Event.where(event_code: event_code).delete
  end

  private

  def event_params
    params.permit(:event_code, :event_name)
  end
end
