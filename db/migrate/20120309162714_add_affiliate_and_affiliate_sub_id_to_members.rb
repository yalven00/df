class AddAffiliateAndAffiliateSubIdToMembers < ActiveRecord::Migration
  def self.up
    add_column :members, :affiliate_id, :string
    add_column :members, :affiliate_sub_id, :string
  end

  def self.down
    remove_column :members, :affiliate_sub_id
    remove_column :members, :affiliate_id
  end
end
