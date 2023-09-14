class AddCoregParamType < ActiveRecord::Migration
  def self.up
    add_column :coreg_params, :field_type, :string
  end

  def self.down
    remove_column :coreg_params, :field_type
  end
end
