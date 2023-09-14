class AddCodeAndCountryToStates < ActiveRecord::Migration
  def self.up
    add_column :states, :code, :string
    add_column :states, :country, :string
  end

  def self.down
    remove_column :states, :country
    remove_column :states, :code
  end
end
