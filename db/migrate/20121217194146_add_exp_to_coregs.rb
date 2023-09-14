class AddExpToCoregs < ActiveRecord::Migration
  def self.up
        add_column :coregs, :expires_on, :timestamp
  end

  def self.down
        remove_column :coregs, :expires_on

  end
end
