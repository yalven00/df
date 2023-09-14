class AddFlatfileLengthToCoregs < ActiveRecord::Migration
  def self.up
    add_column :coreg_params, :flatfile_width, :integer
  end

  def self.down
    remove_column :coreg_params, :flatfile_width
  end
end
