class AddDependentsToCoregParams < ActiveRecord::Migration
  def self.up
    add_column :coreg_params, :dependent_id, :integer
    add_column :coreg_params, :dependent_value, :string
  end

  def self.down
    remove_column :coreg_params, :dependent_id
    remove_column :coreg_params, :dependent_value
  end
end
