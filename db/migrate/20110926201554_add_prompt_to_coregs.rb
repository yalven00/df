class AddPromptToCoregs < ActiveRecord::Migration
  def self.up
    add_column :coregs, :prompt, :text
  end

  def self.down
    remove_column :coregs, :prompt
  end
end
