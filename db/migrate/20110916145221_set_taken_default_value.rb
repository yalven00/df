class SetTakenDefaultValue < ActiveRecord::Migration
  def self.up
    change_column :coreg_optins, :taken, :boolean, :null => false, :default => 0
 end

  def self.down
  end
end
