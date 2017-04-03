Sequel.migration do
  up do
    create_table :states do
      String :state_code, size: 32, primary_key: true
      String :state_name, text: true
      DateTime :updated_at
      DateTime :created_at, null: false
    end

    create_table :events do
      String :event_code, size: 32, primary_key: true
      String :event_name, text: true
      DateTime :updated_at
      DateTime :created_at, null: false
    end


    create_table :workflows do
      primary_key :workflow_id
      String :workflow_name, size: 64, null: false
      String :from_state, size: 32, null: false
      String :to_state, size: 32, null: false
      String :event_code, size: 32, null: false
      DateTime :updated_at
      DateTime :created_at, null: false

      foreign_key [:from_state], :states, name: 'workflows_from_state_fkey'
      foreign_key [:to_state], :states, name: 'workflows_to_state_fkey'
      foreign_key [:event_code], :events, name: 'workflows_events_fkey'
    end

    create_table :devices do
      String :device_guid, size: 64, primary_key: true
      String :device_name, text: true, null: false
      String :device_description, text: true
      String :state_code, size: 32, null: false
      String :workflow_name, size: 64, null: false
      DateTime :updated_at
      DateTime :created_at, null: false

      # foreign_key [:workflow_name], :workflows, name: 'devices_workflows_fkey', key: :workflow_name
    end

    create_table :controllers do
      String :controller_guid, size: 64, primary_key: true
      String :controller_name, text: true, null: false
      String :device_description, text: true
      DateTime :updated_at
      DateTime :created_at, null: false
    end

    create_table :device_controllers do
      primary_key :device_controller_id
      String :controller_guid, size: 64, null: false
      String :device_guid, size: 64, null: false
      DateTime :updated_at
      DateTime :created_at, null: false

      index :controller_guid
      foreign_key [:controller_guid], :controllers, name: 'device_controllers_controllers_fkey'
      foreign_key [:device_guid], :devices, name: 'device_controllers_devices_fkey'
    end

    create_table :event_logs do
      primary_key :event_log_id
      String :event_code, size: 32, null: false
      String :device_guid, size: 64, null: false
      String :controller_guid, size: 64, null: false
      DateTime :request_dt
      DateTime :response_dt
      String :response, size: 32
      DateTime :updated_at
      DateTime :created_at, null: false

      index :request_dt
      index [:device_guid, :controller_guid]
      foreign_key [:event_code], :events, name: 'event_logs_events_fkey'
      foreign_key [:controller_guid], :controllers, name: 'event_logs_controllers_fkey'
      foreign_key [:device_guid], :devices, name: 'event_logs_devices_fkey'
    end
  end

  down do
    drop_table? :event_logs
    drop_table? :device_controllers
    drop_table? :controllers
    drop_table? :devices
    drop_table? :workflows
    drop_table? :events
    drop_table? :states
  end
end
