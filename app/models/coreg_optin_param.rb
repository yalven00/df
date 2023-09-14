class CoregOptinParam < ActiveRecord::Base
  belongs_to :coreg_optin, :inverse_of => :coreg_optin_params
  attr_accessor :coreg_param_id

  #validate :validate_value_based_on_config

  def validate_value_based_on_config

    return unless self.coreg_optin.taken == true # validate only if the parent optin is taken

    if self.coreg_param.required
      if self.value.nil? || self.value.blank?
        errors.add :value, "^Coreg #{self.coreg_param.label} value is required." 
      end
    end

    begin
      if self.coreg_param.match && !self.coreg_param.match.empty?
        match_value = eval(self.coreg_param.match)
        errors.add :value, "^Coreg #{self.coreg_param.label} does not match." unless match_value == self.value 
      end
    rescue Exception => e
      logger.info { "error in matching #{e.message}" }
      # ingore the eval error
    end

    if self.coreg_param.data_type
      
    end

    if self.coreg_param.min_length
      errors.add :value, "^Coreg #{self.coreg_param.label} value must be no shorter than #{self.coreg_param.min_length}" if self.value.nil? || self.value.length < self.coreg_param.min_length
    end
    #errors.add :value, "must be within 5 to 10 characters"
  end

  def coreg_param
    @coreg_param ||= (self.coreg_param_id.nil? ? nil : CoregParam.find(self.coreg_param_id))
  end

  # overrides the active record standard method
  def column_for_attribute(column_name)
    if (column_name == 'value') && !self.coreg_param.nil? && (['date_select', 'month_select'].include? self.coreg_param.try(:field_type).try(:to_s) )
      CoregOptinParamDateColumn
    else
      super(column_name)
    end
  end
end
