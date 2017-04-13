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
    Sequel::Model.db.transaction do
      params.permit(:event_code)
      device_guid = params[:id]
      request_dt = Time.current
      device = Device.first(device_guid: device_guid)
      workflow = Workflow.where(workflow_name: device[:workflow_name], from_state: device[:state_code]).first
      event_log_id = EventLog.create(event_code: params[:event_code], device_guid: device_guid, request_dt: Time.current)[:event_log_id]
      connection_count = ActionCable.server.broadcast 'messages', {
        device_guid: device_guid,
        event_code: params[:event_code],
        request_dt: request_dt,
        event_log_id: event_log_id,
        state_code: workflow[:to_state]
      }
      Rails.logger.info "Broadcasted to #{connection_count} connections"
    end
    sleep(1)
    last_event = EventLog.reverse_order(:request_dt).first

    render json: {
      response: last_event[:response],
      age: age(last_event[:request_dt]).compact,
      id: last_event[:event_log_id]
    }, status: :ok
  end

  private

  def device_params
    params.permit(:device_guid, :device_name, :device_description, :workflow_name, :state_code)
  end

  SECONDS_IN_MINUTE = 60
  SECONDS_IN_HOUR = 60 * 60
  SECONDS_IN_DAY = 60 * 60 * 24
  SECONDS_IN_YEAR = 60 * 60 * 24 * 365

  # Returns negative seconds for future dates
  def age(from_dt)
    to_dt = Time.current

    total_seconds = (to_dt - from_dt).to_i
    Rails.logger.info "From #{from_dt}, To #{to_dt}, seconds: #{total_seconds}"
    seconds = total_seconds
    if total_seconds > SECONDS_IN_YEAR
      years = seconds / SECONDS_IN_YEAR
      seconds -= (years * SECONDS_IN_YEAR)
    end
    if total_seconds > SECONDS_IN_DAY
      days = seconds / SECONDS_IN_DAY
      seconds -= (days * SECONDS_IN_DAY)
    end
    if total_seconds > SECONDS_IN_HOUR
      hours = seconds / SECONDS_IN_HOUR
      seconds -= (hours * SECONDS_IN_HOUR)
    end
    if total_seconds > SECONDS_IN_MINUTE
      minutes = seconds / SECONDS_IN_MINUTE
      seconds -= (minutes * SECONDS_IN_MINUTE)
    end
    return {years: years, days: days, hours: hours, minutes: minutes, seconds: seconds}
  end
end
