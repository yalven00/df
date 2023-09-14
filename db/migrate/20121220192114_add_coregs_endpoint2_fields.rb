class AddCoregsEndpoint2Fields < ActiveRecord::Migration
  def self.up
    add_column :coregs, :endpoint2, :string
    add_column :coregs, :endpoint2_delay, :string
  end

  def self.down
    remove_column :coregs, :endpoint2
    remove_column :coregs, :endpoint2_delay
  end
end
