class AddCoregRequestMethod < ActiveRecord::Migration
  def self.up
    add_column :coregs, :request_method, :string, :default => 'post'
  end

  def self.down
    remove_column :coregs, :request_method
  end
end
