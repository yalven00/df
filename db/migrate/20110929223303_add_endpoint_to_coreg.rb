class AddEndpointToCoreg < ActiveRecord::Migration
  def self.up
    add_column :coregs, :endpoint, :string
  end

  def self.down
    remove_column :coregs, :endpoint
  end
end
