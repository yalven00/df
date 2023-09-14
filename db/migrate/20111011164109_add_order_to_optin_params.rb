class AddOrderToOptinParams < ActiveRecord::Migration
  def self.up
    add_column :coreg_params, :sequence, :integer
  end

  def self.down
    remove_column :coreg_params, :sequence
  end
end
