class FullPageCoregSender

  @queue = :full_page_coreg_queue

  def self.perform(coreg_id, data, serial)
    #Rails.logger.info "#"*100
    #Rails.logger.info { "#{optin_data.inspect}" }
    coreg = Coreg.find(coreg_id)
    optin = CoregOptin.create :coreg => coreg, :hashcode => serial, :taken => 1, :params => data.to_hash
    optin.register_with_coreg(data)
  end
end


