class AddSentToCoregOptins < ActiveRecord::Migration
  def self.up
    add_column :coreg_optins, :sent, :boolean
  end

  def self.down
    remove_column :coreg_optins, :sent
  end
end
