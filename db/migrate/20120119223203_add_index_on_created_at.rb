class AddIndexOnCreatedAt < ActiveRecord::Migration
  def self.up
    add_index :requests, :created_at
    add_index :members, [:created_at, :partner_id]
    add_index :coreg_optins, :created_at
  end

  def self.down
    remove_index :requests, :created_at
    remove_index :members, [:created_at, :partner_id]
    remove_index :coreg_optins, :created_at
  end
end
