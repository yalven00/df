class AddSuccessRegexToCoregs < ActiveRecord::Migration
  def self.up
    add_column :coregs, :success_regex, :string
  end

  def self.down
    remove_column :coregs, :success_regex, :string
  end
end
