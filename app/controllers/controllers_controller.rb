class ControllersController < ApplicationController
  def index
    render json: Controller.all, status: :ok
  end

  def create
    Rails.logger.info "Creating new controller with params #{params.to_json}"
    controller = Controller.create(controller_params)
    render json: controller, status: :ok
  end

  def show
    controller_guid = params[:id]
    controller = Controller.first(controller_guid: controller_guid)
    render json: controller, status: :ok
  end

  def update
    controller_guid = params[:id]
    Rails.logger.info "Updating controller #{controller_guid} with params #{params.to_json}"
    controller = Controller.where(controller_guid: controller_guid).update(
      controller_name: params[:controller_name],
      controller_description: params[:controller_description]
    )
    render json: controller, status: :ok
  end

  def destroy
    controller_guid = params[:id]
    Rails.logger.warn "Deleting controller #{controller_guid}"
    Controller.where(controller_guid: controller_guid).delete
  end

  def connections
    connection_count = ActionCable.server.connections.length
    active_count = ActionCable.server.connections.select(&:beat).count
    Rails.logger.info "There are #{connection_count} connections"
    render json: {connection_count: connection_count, active_count: active_count}, status: :ok
  end

  def connections_test
    connection_count = ActionCable.server.broadcast 'messages', {}
    Rails.logger.info "Broadcasted to #{connection_count} connections"
    render json: {count: connection_count}, status: :ok
  end

  def connections_details
    connection_details = ActionCable.server.open_connections_statistics.reverse
    Rails.logger.info "There are #{connection_details} connections"
    render json: connection_details, status: :ok
  end

  private

  def controller_params
    params.permit(:controller_guid, :controller_name, :controller_description)
  end
end