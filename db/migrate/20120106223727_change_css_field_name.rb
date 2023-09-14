class ChangeCssFieldName < ActiveRecord::Migration
  def self.up
    remove_column :pages, :string
    add_column :pages, :css_snippet, :text
  end

  def self.down
    remove_column :pages, :css_snippet
    add_column :pages, :string, :text    
  end
end
