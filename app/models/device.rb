class Device < Sequel::Model
  def before_create
    values[:device_guid] ||= SecureRandom.uuid
    values[:created_at] ||= Time.current
    super
  end
end
