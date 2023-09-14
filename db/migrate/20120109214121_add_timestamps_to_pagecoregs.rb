class AddTimestampsToPagecoregs < ActiveRecord::Migration
  def self.up
    change_table :page_coregs do |t| 
      t.timestamps
    end
  end

  def self.down
  end
end
