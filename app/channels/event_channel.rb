class EventChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    stream_from 'messages'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def signal
    ActionCable.server.broadcast('messages', message: "TEST")
  end
end
