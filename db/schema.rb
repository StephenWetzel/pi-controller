Sequel.migration do
  change do
    create_table(:devices) do
      column :device_guid, "character varying(32)", :null=>false
      column :device_name, "text"
      column :device_description, "text"
      column :updated_at, "timestamp without time zone"
      column :created_at, "timestamp without time zone"
      
      primary_key [:device_guid]
    end
    
    create_table(:schema_info) do
      column :version, "integer", :default=>0, :null=>false
    end
  end
end
Sequel.migration do
  change do
    self << "SET search_path TO \"$user\", public"
    self << "INSERT INTO \"schema_info\" (\"version\") VALUES (1)"
  end
end
