class AddDefaultTakenValue < ActiveRecord::Migration
  def self.up
    add_column :coregs, :taken_default, :string
  end

  def self.down
    remove_column :coregs, :taken_default
  end
end
