class AddFlatfilePatternToCoregs < ActiveRecord::Migration
  def self.up
    add_column :coregs, :flatfile_pattern, :string
  end

  def self.down
    remove_column :coregs, :flatfile_pattern
  end
end
