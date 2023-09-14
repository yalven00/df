class AddIpToRequest < ActiveRecord::Migration
  def self.up
    add_column :requests, :ip_address, :string 
  end

  def self.down
    remove_column :requests, :ip_address
  end
end
