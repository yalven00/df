class AddCoregParamGroupId < ActiveRecord::Migration
  def self.up
    add_column :coreg_params, :group_id, :integer
   end

  def self.down
    remove_column :coreg_params, :group_id
  end
end
