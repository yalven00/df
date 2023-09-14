class AddIndexToCoregOptinHashcode < ActiveRecord::Migration
  def self.up
    add_index :coreg_optins, :hashcode
  end

  def self.down
    remove_index :coreg_optins, :hashcode
  end
end
