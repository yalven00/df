class CreateCoregOptins < ActiveRecord::Migration
  def self.up
    create_table :coreg_optins do |t|
      t.integer :coreg_id
      t.integer :member_id
      t.text :response

      t.timestamps
    end
  end

  def self.down
    drop_table :coreg_optins
  end
end
