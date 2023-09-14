class CreateCoregOptinParams < ActiveRecord::Migration
  def self.up
    create_table :coreg_optin_params do |t|
      t.integer :coreg_optin_id
      t.string :key
      t.string :value
    end
  end

  def self.down
    drop_table :coreg_optin_params
  end
end
