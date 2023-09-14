class AddZipCodeToMembers < ActiveRecord::Migration
  def self.up
    add_column :members, :zip_code, :string
  end

  def self.down
    remove_column :members, :zip_code
  end
end
