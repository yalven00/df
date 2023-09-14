class AddRunDaysToCoregs < ActiveRecord::Migration
  def self.up
    add_column :coregs, :run_days, :string
  end

  def self.down
    remove_column :coregs, :run_days
  end
end
