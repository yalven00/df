class CreateChildren < ActiveRecord::Migration
  def self.up
    create_table :children do |t|
      t.datetime :dob
      t.string :gender
      t.references :member

      t.timestamps
    end
  end

  def self.down
    drop_table :children
  end
end
