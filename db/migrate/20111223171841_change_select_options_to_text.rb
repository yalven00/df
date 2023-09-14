class ChangeSelectOptionsToText < ActiveRecord::Migration
  def self.up
    change_column :coreg_params, :select_options, :text 
  end

  def self.down
    change_column :coreg_params, :select_options, :string
  end
end
