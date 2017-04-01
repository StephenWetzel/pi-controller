class EventChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    stream_from 'messages'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def signal(data)
    message = data['message']
    Rails.logger.info "SIGNAL: #{message}"
    # ActionCable.server.broadcast('messages', message: "TEST: #{message}")
  end
end
