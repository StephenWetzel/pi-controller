Sequel.migration do
  up do
    create_table :devices do
      String :device_guid, size: 32, primary_key: true
      String :device_name, text: true
      String :device_description, text: true
      DateTime :updated_at
      DateTime :created_at
    end


    devices = Sequel::Model.db[:devices]
    devices.insert(device_guid: "abc", device_name: "Cat", created_at: Time.current, updated_at: Time.current)
  end

  down do
    drop_table? :devices
  end
end
