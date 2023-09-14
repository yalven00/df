class AddValidationsMatchField < ActiveRecord::Migration
  def self.up
    add_column :coreg_params, :match, :string
  end

  def self.down
    remove_column :coreg_params, :match
  end
end
