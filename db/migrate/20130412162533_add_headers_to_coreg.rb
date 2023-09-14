class AddHeadersToCoreg < ActiveRecord::Migration
  def self.up
    add_column :coregs, :headers, :string
  end

  def self.down
    remove_column :coregs, :headers
  end
end
