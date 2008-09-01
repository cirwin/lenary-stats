class CreateStats < ActiveRecord::Migration
  def self.up
    create_table :stats do |t|
      t.string :session_id, :limit => 32 # Session ID
      t.string :path # Requested Path
      t.string :method # Requested Method Type, eg GET
      t.string :controller # Requested Controller
      t.string :action # Requested Action
      t.string :params # Request Paramaters, stored as a hash

      t.string :for # IP Address
      
      t.float :total # Total Process Time, Seconds
      t.float :render # Render Time, Seconds
      t.float :db # Database Time, Seconds
      
      t.integer :status # HTTP Response Code
      
      t.time :at # Request Time

      t.timestamps # created_at and updated_at
    end
  end

  def self.down
    drop_table :stats
  end
end
