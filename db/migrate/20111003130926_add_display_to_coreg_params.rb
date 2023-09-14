class AddDisplayToCoregParams < ActiveRecord::Migration
  def self.up
    add_column :coreg_params, :display, :boolean, :null => false, :default => 0 
  end

  def self.down
    remove_column :coreg_params, :display
  end
end
