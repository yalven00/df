class AddValueToCoregParams < ActiveRecord::Migration
  def self.up
    add_column :coreg_params, :value, :string
  end

  def self.down
    remove_column :coreg_params, :value
  end
end
