class AddDescriptionToCoreg < ActiveRecord::Migration
  def self.up
    add_column :coregs, :description, :text
  end

  def self.down
    remove_column :coregs, :description
  end
end
