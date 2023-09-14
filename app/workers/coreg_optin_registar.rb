class CoregOptinRegistar

  @queue = :coreg_optin_registar

  def self.perform(coreg_optin_id, auth_data)
    CoregOptin.find(coreg_optin_id).register_with_coreg(auth_data)
  end
end
