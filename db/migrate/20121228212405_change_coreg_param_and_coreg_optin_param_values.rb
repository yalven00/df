class ChangeCoregParamAndCoregOptinParamValues < ActiveRecord::Migration
  def self.up
    change_column :coreg_params, :value, :text
    change_column :coreg_optin_params, :value, :text
  end

  def self.down
    change_column :coreg_params, :value, :string
    change_column :coreg_optin_params, :value, :string
  end
end
