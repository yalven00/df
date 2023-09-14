class AddValidationFields < ActiveRecord::Migration
  def self.up
    add_column :coreg_params, :required, :boolean
    add_column :coreg_params, :data_type, :string
    add_column :coreg_params, :min_length, :integer
  end

  def self.down
    remove_column :coreg_params, :required
    remove_column :coreg_params, :data_type
    remove_column :coreg_params, :min_length
  end
end
