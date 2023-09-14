class AddSelectOptions < ActiveRecord::Migration
  def self.up
    add_column :coreg_params, :select_options, :string
  end

  def self.down
    remove_column :coreg_params, :select_options
  end
end
