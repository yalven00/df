class CreatePageCoregs < ActiveRecord::Migration
  def self.up
    create_table :page_coregs do |t|
      t.integer :coreg_id
      t.integer :page_id
    end
  end

  def self.down
    drop_table :page_coregs
  end
end
