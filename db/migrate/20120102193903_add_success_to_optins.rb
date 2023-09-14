class AddSuccessToOptins < ActiveRecord::Migration
  def self.up
    add_column :coreg_optins, :success, :boolean
  end

  def self.down
    remove_column :coreg_optins, :success
  end
end
