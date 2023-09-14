class AddAcceptanceToCoreg < ActiveRecord::Migration
  def self.up
    add_column :coregs, :acceptance, :text
  end

  def self.down
    remove_column :coregs, :acceptance
  end
end
