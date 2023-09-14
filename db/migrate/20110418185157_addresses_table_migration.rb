class AddressesTableMigration < ActiveRecord::Migration
  def self.up
		rename_column :addresses, :street, :address1
		rename_column :addresses, :zip, :postal
		rename_column :members, :zip_code, :postal_code
	  add_column :addresses, :address2, :string
  end

  def self.down
		rename_column :addresses, :address1, :street
		rename_column :addresses, :postal, :zip
		rename_column :members, :postal_code, :zip_code
		remove_column :addresses, :address2
  end
end
