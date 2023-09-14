class AddCoregOptinMemberIndex < ActiveRecord::Migration
  def self.up
    add_index :coreg_optins, :member_id
  end

  def self.down
    remove_index :coreg_optins, :member_id
  end
end
