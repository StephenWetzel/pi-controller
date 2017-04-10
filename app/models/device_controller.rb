class DeviceController < Sequel::Model
  def before_create
    values[:created_at] ||= Time.current
    super
  end
end
