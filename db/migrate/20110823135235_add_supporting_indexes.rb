class AddSupportingIndexes < ActiveRecord::Migration
  def self.up
    add_index :members, :partner_id
    add_index :members, :email
    add_index :addresses, :member_id
    add_index :children, :member_id
  end

  def self.down
    remove_index :members, :column => :partner_id
    remove_index :members, :column => :email
    remove_index :addresses, :column => :member_id
    remove_index :children, :column => :member_id
  end
end