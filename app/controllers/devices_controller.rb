class DevicesController < ApplicationController
  def index # Display all devices
    render json: Device.all, status: :ok
  end

  def create # Create a new device
    Rails.logger.info "Creating new device with params #{params.to_json}"
    device = Device.create(device_params)
    render json: device, status: :ok
  end

  def show # Display a specific device
    device_guid = params[:id]
    device = Device.first(device_guid: device_guid)
    workflows = Workflow.where(workflow_name: device[:workflow_name])
    device[:workflows] = workflows
    render json: device, status: :ok
  end

  def update # Update a specific device
    device_guid = params[:id]
    Rails.logger.info "Updating device #{device_guid} with params #{params.to_json}"
    #puts "Device params: " + device_params
    device = Device.where(device_guid: device_guid).update(
      device_name: params[:device_name],
      device_description: params[:device_description],
      workflow_name: params[:workflow_name],
      state_code: params[:state_code]
    )
    render json: device, status: :ok
  end

  def destroy # Delete a specific device
    device_guid = params[:id]
    Rails.logger.warn "Deleting device #{device_guid}"
    Device.where(device_guid: device_guid).delete
  end

  def event # send event to device
    device_guid = params[:id]
    message = "TEST message from DevicesController #{device_guid}"
    Rails.logger.info "Message: #{message}"
    connection_count = ActionCable.server.broadcast 'messages', {message: message}
    Rails.logger.info "Broadcasted to #{connection_count} connections"
    render json: Device.first(device_guid: device_guid), status: :ok
  end

  private

  def device_params
    params.permit(:device_name, :device_description, :workflow_name, :state_code)
  end
end
