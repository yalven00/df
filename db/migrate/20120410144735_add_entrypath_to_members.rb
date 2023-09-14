class AddEntrypathToMembers < ActiveRecord::Migration
  def self.up
    add_column :members, :entrypath, :string
  end

  def self.down
    remove_column :members, :entrypath
  end
end
