class AddPriceToCoreg < ActiveRecord::Migration
  def self.up
    add_column :coregs, :revenue, :float, :default => 0
  end

  def self.down
    remove_column :coregs, :revenue
  end
end
