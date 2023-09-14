class AddEwayMessagesTable < ActiveRecord::Migration
  def self.up
    create_table :eway_messages do |t|
      t.integer :member_id
      t.string  :message
    end
  end

  def self.down
    drop_table :eway_messages
  end
end
