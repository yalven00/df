class AddEmailFieldToCoreg < ActiveRecord::Migration
  def self.up
    add_column :coregs, :email_field, :string
  end

  def self.down
    remove_column :coregs, :email_field
  end
end
