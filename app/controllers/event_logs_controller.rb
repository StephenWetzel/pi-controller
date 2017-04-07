class EventLogsController < ApplicationController
  def index
    render json: EventLog.reverse_order(:request_dt).all, status: :ok
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
    render json: EventLog.reverse_order(:request_dt).limit(params[:event_count]).all, status: :ok
  end
end
