class CoregSender

  @queue = :coreg_queue

  def self.perform(optin_data, serial)
    
    #Rails.logger.info "#"*100
    #Rails.logger.info { "#{optin_data.inspect}" }
    
    auth_data = {}
    auth_data['xxTrustedFormCertUrl'] = optin_data.delete('xxTrustedFormCertUrl')
    auth_data['xxTrustedFormToken'] = optin_data.delete('xxTrustedFormToken')
    
    #Rails.logger.info "#"*100
 
    coregs = optin_data.keys.collect {|i| CoregParam.find(i).coreg }.uniq
    coregs.each do |coreg|
      optin = CoregOptin.new :coreg => coreg, :hashcode => serial, :taken => 1
      coreg.coreg_params.each do |param|
        name = param.name
        # coreg data_hash has all the data that needs to send to the coreg endpoint 
        # it has two situations
        # 1. if the coreg has a default value. it will be either hard coded as "NO" or Time.now so that it will be evaludated
        # 2. if will take it from the coreg params
        value = param.on_screen? ? optin_data[param.id.to_s] : Evaluator.new(coreg, optin_data, serial).evaluate(param.value)
        optin.coreg_optin_params.build :name => name, :value => value
      end
      optin.save!

      # send the optin to external apis and register results
      if delay = optin.coreg.time_delay
        Resque.enqueue_at(eval(delay).from_now, CoregOptinRegistar, optin.id, auth_data)
      else
        optin.register_with_coreg(auth_data)
        if endpoint2_delay = optin.coreg.endpoint2_delay
          Resque.enqueue_at(eval(endpoint2_delay).from_now, CoregOptinRegistar, optin.id, auth_data)
        end
      end

      if email_value = optin.send(:optin_value_hash)[coreg.email_field]
        optin.update_attribute(:email, email_value)
        member = Member.find_by_email(email_value)
        optin.update_attribute(:member_id, member.id) if member
      end
    end
  end
end

