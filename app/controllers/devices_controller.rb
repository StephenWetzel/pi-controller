class DevicesController < ApplicationController
  def index
    render json: Device.all, status: :ok
  end

  def show
    message = "TEST message from DevicesController #{params[:device_guid]}"
    ActionCable.server.broadcast 'messages', {message: message}

    render json: Device.first(device_guid: params[:device_guid]), status: :ok
  end
end
