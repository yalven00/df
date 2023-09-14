class AddHashcodeToOptin < ActiveRecord::Migration
  def self.up
    add_column :coreg_optins, :hashcode, :string
  end

  def self.down
    remove_column :coreg_optins, :hashcode
  end
end
