Sequel.migration do
  up do
    states = Sequel::Model.db[:states]
    states.insert(state_code: "ON", state_name: "On", created_at: Time.current)
    states.insert(state_code: "OFF", state_name: "Off", created_at: Time.current)

    events = Sequel::Model.db[:events]
    events.insert(event_code: "GO", event_name: "Go", created_at: Time.current)

    workflows = Sequel::Model.db[:workflows]
    workflows.insert(workflow_name: "Single", from_state: "ON", to_state: "ON", event_code: "GO", created_at: Time.current)
    workflows.insert(workflow_name: "Basic", from_state: "ON", to_state: "OFF", event_code: "GO", created_at: Time.current)
    workflows.insert(workflow_name: "Basic", from_state: "OFF", to_state: "ON", event_code: "GO", created_at: Time.current)

    devices = Sequel::Model.db[:devices]
    device_guid = SecureRandom.uuid
    devices.insert(device_guid: device_guid, device_name: "Laser", workflow_name: 'Single', state_code: "ON", created_at: Time.current)

    controllers = Sequel::Model.db[:controllers]
    controller_guid = SecureRandom.uuid
    controllers.insert(controller_guid: controller_guid, controller_name: "Pi", created_at: Time.current)

    device_controllers = Sequel::Model.db[:device_controllers]
    device_controllers.insert(device_guid: device_guid, controller_guid: controller_guid, created_at: Time.current)
  end

  down do
    # Sequel::Model.db[:device_controllers].truncate
    # Sequel::Model.db[:controllers].truncate
    # Sequel::Model.db[:devices].truncate
    # Sequel::Model.db[:workflows].truncate
    # Sequel::Model.db[:events].truncate
    # Sequel::Model.db[:states].truncate
  end
end
