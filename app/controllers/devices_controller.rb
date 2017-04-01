class DevicesController < ApplicationController
  def index
    render json: Device.all.to_json, status: :ok
  end

  def show
    render json: Device.first(device_guid: params[:device_guid]).to_json, status: :ok
  end
end
