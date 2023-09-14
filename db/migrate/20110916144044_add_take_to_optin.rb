class AddTakeToOptin < ActiveRecord::Migration
  def self.up
    add_column :coreg_optins, :taken, :boolean
  end

  def self.down
    remove_column :coreg_optins, :taken
  end
end
