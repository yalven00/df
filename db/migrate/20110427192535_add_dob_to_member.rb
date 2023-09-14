class AddDobToMember < ActiveRecord::Migration
  def self.up
    add_column :members, :dob, :datetime
  end

  def self.down
    remove_column :members, :dob
  end
end
