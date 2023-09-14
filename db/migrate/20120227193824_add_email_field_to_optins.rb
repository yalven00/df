class AddEmailFieldToOptins < ActiveRecord::Migration
  def self.up
    add_column :coreg_optins, :email, :string
  end

  def self.down
    remove_column :coreg_optins, :email
  end
end
