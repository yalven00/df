class AddRequestsHashcodeIndex < ActiveRecord::Migration
  def self.up
    add_index :requests, :hashcode#, :unique => true
  end

  def self.down
    remove_index :coreg_optins, :hashcode
  end
end
