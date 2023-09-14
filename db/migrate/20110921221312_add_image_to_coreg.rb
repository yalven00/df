class AddImageToCoreg < ActiveRecord::Migration
  def self.up
    add_column :coregs, :image, :string
  end

  def self.down
    remove_column :coregs, :image
  end
end
