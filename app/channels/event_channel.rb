class EventChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'messages'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def response(data)
    response_dt = data['response_dt']
    response = data['response']
    event_log_id = data['event_log_id']
    Rails.logger.info "RESPONSE: #{data}"
    sleep(0.1) # Concurrency, how does it work?
    EventLog.where(event_log_id: event_log_id).update(response_dt: Time.parse(response_dt).utc, response: response)
    return true
  end
end
