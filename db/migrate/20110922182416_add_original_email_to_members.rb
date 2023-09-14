class AddOriginalEmailToMembers < ActiveRecord::Migration
  def self.up
    add_column :members, :original_email, :string
  end

  def self.down
    remove_column :members, :original_email
  end
end