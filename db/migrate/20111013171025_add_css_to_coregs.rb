class AddCssToCoregs < ActiveRecord::Migration
  def self.up
    add_column :coregs, :css_snippet, :text
  end

  def self.down
    remove_column :coregs, :css_snippet
  end
end
