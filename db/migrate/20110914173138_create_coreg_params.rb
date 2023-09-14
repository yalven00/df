class CreateCoregParams < ActiveRecord::Migration
  def self.up
    create_table :coreg_params do |t|
      t.integer :coreg_id
      t.string :name
      t.string :label

      t.timestamps
    end
  end

  def self.down
    drop_table :coreg_params
  end
end
