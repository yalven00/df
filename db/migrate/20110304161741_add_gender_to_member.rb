class AddGenderToMember < ActiveRecord::Migration
  def self.up
    add_column :members, :gender, :string, :default => 'F'
  end

  def self.down
    remove_column :members, :gender
  end
end
