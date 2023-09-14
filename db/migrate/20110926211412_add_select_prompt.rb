class AddSelectPrompt < ActiveRecord::Migration
  def self.up
    add_column :coreg_params, :select_prompt, :string
  end

  def self.down
    remove_column :coreg_params, :select_prompt
  end
end
