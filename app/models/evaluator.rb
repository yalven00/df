class Evaluator
  attr_accessor :optin_param, :serial

  def initialize(coreg, optin_hash,serial)
    @coreg = coreg
    @optin_hash = optin_hash
    @serial = serial
  end

  def evaluate(param_value)
    eval param_value
  end

  private
  def v(param_name)
    @optin_hash[CoregParam.find_by_coreg_id_and_name(@coreg.id, param_name.to_s).id.to_s]
  end
end
