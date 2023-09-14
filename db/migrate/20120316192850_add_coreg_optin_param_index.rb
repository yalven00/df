class AddCoregOptinParamIndex < ActiveRecord::Migration
  def self.up
    add_index :coreg_optin_params, :coreg_optin_id
  end

  def self.down
    remove_index :coreg_optin_params, :coreg_optin_id
  end
end
