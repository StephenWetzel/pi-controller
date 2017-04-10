class State < Sequel::Model
  State.unrestrict_primary_key
  def before_create
    values[:created_at] ||= Time.current
    super
  end
end
