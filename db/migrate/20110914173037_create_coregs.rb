class CreateCoregs < ActiveRecord::Migration
  def self.up
    create_table :coregs do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :coregs
  end
end
