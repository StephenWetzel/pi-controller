class EventLogsController < ApplicationController
  include Helper
  def index
    event_log = EventLog.reverse_order(:request_dt).all
    event_log.map { |el| el[:age] = age(el[:request_dt]) }
    render json: event_log, status: :ok
  end

  def create
    Rails.logger.warn "Create event log"
  end

  def show
    render json: EventLog.first(event_log_id: params[:id]), status: :ok
  end

  def update
    Rails.logger.warn "Update event log"
  end

  def destroy
    Rails.logger.warn "Delete event log"
  end

  def get_count
    event_log = EventLog.reverse_order(:request_dt).limit(params[:event_count]).all
    event_log.map { |el| el[:age] = age(el[:request_dt]) }
    render json: event_log, status: :ok
  end
end
