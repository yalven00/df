class AddParamsToCoregs < ActiveRecord::Migration
  def self.up
    add_column :coreg_optins, :params, :text
  end

  def self.down
    remove_column :coreg_optins, :params
  end
end
