Sequel.migration do
  change do
    create_table(:controllers) do
      column :controller_guid, "character varying(64)", :null=>false
      column :controller_name, "text", :null=>false
      column :controller_description, "text"
      column :updated_at, "timestamp without time zone"
      column :created_at, "timestamp without time zone", :null=>false
      
      primary_key [:controller_guid]
    end
    
    create_table(:devices) do
      column :device_guid, "character varying(64)", :null=>false
      column :device_name, "text", :null=>false
      column :device_description, "text"
      column :state_code, "character varying(32)", :null=>false
      column :workflow_name, "character varying(64)", :null=>false
      column :updated_at, "timestamp without time zone"
      column :created_at, "timestamp without time zone", :null=>false
      
      primary_key [:device_guid]
    end
    
    create_table(:events) do
      column :event_code, "character varying(32)", :null=>false
      column :event_name, "text"
      column :updated_at, "timestamp without time zone"
      column :created_at, "timestamp without time zone", :null=>false
      
      primary_key [:event_code]
    end
    
    create_table(:schema_info) do
      column :version, "integer", :default=>0, :null=>false
    end
    
    create_table(:states) do
      column :state_code, "character varying(32)", :null=>false
      column :state_name, "text"
      column :updated_at, "timestamp without time zone"
      column :created_at, "timestamp without time zone", :null=>false
      
      primary_key [:state_code]
    end
    
    create_table(:device_controllers) do
      primary_key :device_controller_id
      foreign_key :controller_guid, :controllers, :type=>"character varying(64)", :null=>false, :key=>[:controller_guid]
      foreign_key :device_guid, :devices, :type=>"character varying(64)", :null=>false, :key=>[:device_guid]
      column :updated_at, "timestamp without time zone"
      column :created_at, "timestamp without time zone", :null=>false
      
      index [:controller_guid]
    end
    
    create_table(:event_logs) do
      primary_key :event_log_id
      foreign_key :event_code, :events, :type=>"character varying(32)", :null=>false, :key=>[:event_code]
      foreign_key :device_guid, :devices, :type=>"character varying(64)", :null=>false, :key=>[:device_guid]
      column :request_dt, "timestamp without time zone"
      column :response_dt, "timestamp without time zone"
      column :response, "character varying(32)"
      column :updated_at, "timestamp without time zone"
      column :created_at, "timestamp without time zone", :null=>false
      
      index [:device_guid]
      index [:request_dt]
    end
    
    create_table(:workflows) do
      primary_key :workflow_id
      column :workflow_name, "character varying(64)", :null=>false
      foreign_key :from_state, :states, :type=>"character varying(32)", :null=>false, :key=>[:state_code]
      foreign_key :to_state, :states, :type=>"character varying(32)", :null=>false, :key=>[:state_code]
      foreign_key :event_code, :events, :type=>"character varying(32)", :null=>false, :key=>[:event_code]
      column :updated_at, "timestamp without time zone"
      column :created_at, "timestamp without time zone", :null=>false
      
      index [:workflow_name, :from_state], :name=>:workflows_workflow_name_from_state_key, :unique=>true
    end
  end
end
Sequel.migration do
  change do
    self << "SET search_path TO \"$user\", public"
    self << "INSERT INTO \"schema_info\" (\"version\") VALUES (2)"
  end
end
