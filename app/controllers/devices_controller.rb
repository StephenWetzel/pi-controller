class DevicesController < ApplicationController
  def index
    render json: Device.all, status: :ok
  end

  def show
    message = "TEST message from DevicesController #{params[:device_guid]}"
    Rails.logger.info "Message: #{message}"
    connection_count = ActionCable.server.broadcast 'messages', {message: message}
    Rails.logger.info "Broadcasted to #{connection_count} connections"
    render json: Device.first(device_guid: params[:device_guid]), status: :ok
  end
end
