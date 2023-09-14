class ChangeDataTypeForPartnerIdInt < ActiveRecord::Migration
  def self.up
    #change_column :my_table, :my_column, :datetime
    change_column :members, :partner_id, :integer
  end

  def self.down
    change_column :members, :partner_id, :string
  end
end
