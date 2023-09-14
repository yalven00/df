class AddScreenKeyToCoregs < ActiveRecord::Migration
  def self.up
    add_column :coregs, :screen_key, :string
  end

  def self.down
    remove_column :coregs, :screen_key
  end
end
