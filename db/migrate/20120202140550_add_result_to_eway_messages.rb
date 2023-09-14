class AddResultToEwayMessages < ActiveRecord::Migration
  def self.up
    add_column :eway_messages, :result, :string
  end

  def self.down
    remove_column :eway_messages, :result
  end
end
