class IndexEmailFieldToOptins < ActiveRecord::Migration
  def self.up
    add_index :coreg_optins, :email
  end

  def self.down
    remove_index :coreg_optins, :email
  end
end
