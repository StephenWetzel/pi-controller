class Controller < Sequel::Model
  def before_create
    values[:controller_guid] ||= SecureRandom.uuid
    values[:created_at] ||= Time.current
    super
  end
end
