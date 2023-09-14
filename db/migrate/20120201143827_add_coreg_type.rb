class AddCoregType < ActiveRecord::Migration
  def self.up
    add_column :coregs, :coreg_type, :string, :default => 'compact'
    add_index :coregs, :coreg_type
  end

  def self.down
    remove_column :coregs, :coreg_type
  end
end
