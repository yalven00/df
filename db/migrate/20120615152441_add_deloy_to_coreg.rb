class AddDeloyToCoreg < ActiveRecord::Migration
  def self.up
    add_column :coregs, :time_delay, :string
  end

  def self.down
    remove_column :coregs, :time_delay, :string
  end
end
