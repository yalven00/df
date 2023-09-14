class ChangeOptinParamsKeyToName < ActiveRecord::Migration
  def self.up
    rename_column :coreg_optin_params, :key, :name
  end

  def self.down
    rename_column :coreg_optin_params, :name, :key
  end
end
