class RequestRegister

  @queue = :request_queue

  def self.perform(hash_code, ip, affiliate_id, affiliate_sub_id)
    Request.create(:hashcode => hash_code, :ip_address => ip, :affiliate_id => affiliate_id, :affiliate_sub_id => affiliate_sub_id)
  end

end


