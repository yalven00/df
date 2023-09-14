class AddPartnerIdToMember < ActiveRecord::Migration
  def self.up
		add_column :members, :partner_id, :string, :default => '0'
  end

  def self.down
		 remove_column :members, :partner_id
  end
end