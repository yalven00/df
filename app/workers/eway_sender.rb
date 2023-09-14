class EwaySender

  @queue = :eway_queue

  def self.perform(method, *args)
    #Rails.logger.info "#"*100
    #Rails.logger.info { "#{optin_data.inspect}" }
    result = Eway.new.send(method.to_sym, *args)
    EwayMessage.create :member_id => args.first, :message => method, :result => result
  end
end


