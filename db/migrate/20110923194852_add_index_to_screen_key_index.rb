class AddIndexToScreenKeyIndex < ActiveRecord::Migration
  def self.up
    add_index :coregs, :screen_key
  end

  def self.down
    remove_index :coregs, :screen_key
  end
end
