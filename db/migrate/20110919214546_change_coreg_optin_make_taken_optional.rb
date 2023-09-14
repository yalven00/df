class ChangeCoregOptinMakeTakenOptional < ActiveRecord::Migration
  def self.up
    change_column :coreg_optins, :taken, :boolean, :null => true, :default => nil
  end

  def self.down
    change_column :coreg_optins, :taken, :boolean, :null => false
  end
end
