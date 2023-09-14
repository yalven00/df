class AddAffiliateAndAffiliateSubIdToRequests < ActiveRecord::Migration
  def self.up
    add_column :requests, :affiliate_id, :string
    add_column :requests, :affiliate_sub_id, :string
  end

  def self.down
    remove_column :requests, :affiliate_sub_id
    remove_column :requests, :affiliate_id
  end
end
