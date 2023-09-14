class CoregOptin < ActiveRecord::Base
  belongs_to :member, :inverse_of => :coreg_optins
  belongs_to :coreg
  has_many :coreg_optin_params, :inverse_of => :coreg_optin
  accepts_nested_attributes_for :coreg_optin_params
  #validates_associated :coreg_optin_params, :if => :rejection_params_condition
  validates_presence_of :coreg
  serialize :params
  # for get uri encoding
  require 'uri'
  
  #after_initialize :create_optin_params
  def create_optin_params
    if self.new_record? && self.coreg_optin_params.empty?# only applies to new records
      self.taken = self.coreg.taken_default
      if self.coreg_optin_params.empty? && (coreg = self.coreg)
        coreg.coreg_params.each {|x| self.coreg_optin_params.build({:name => x.name, :coreg_param_id => x.id}) if x.display } 
      end
    end
  end

  def register_with_coreg(auth_data)
    return if success # do nothing if already success
    unless acceptable? 
      self.success = false
      self.response = 'REJECTED INTERALLY -- NOT SENT'
    else
      unless self.coreg.email_file?
        if !self.coreg.headers.blank?
          headers = YAML.load(self.coreg.headers).symbolize_keys!()
        end

        data = self.params || Hash[self.coreg_optin_params.map {|p| [p.name, p.value]}]

        result =  if self.coreg.post? && !self.coreg.headers.blank?
                    RestClient.post(self.coreg.endpoint, data.merge(auth_data), headers)
                  elsif self.coreg.post?
                    RestClient.post(self.coreg.endpoint, data.merge(auth_data))
                  elsif self.coreg.xml?
                    headers={:content_type=>"application/xml", :username=>"ParentMediaAPIAdmin", :password=>"ParentMedia1615"}
                    RestClient.post(self.coreg.endpoint, self.xml_query, headers)                    
                  elsif self.coreg.get?
                    RestClient.get self.full_query
                  end

        self.response = result
        self.success = successful?
        self.sent = true
      else
        # emal batch processing coreg
        self.success = true
        self.sent = false
      end 
    end
    self.save
  end

  def full_query
    query_params = optin_value_hash.map {|k,v| "#{k}=#{v}"}.join('&')
    URI.escape "#{current_endpoint}#{current_endpoint.include?('?')? '&' : '?'}#{query_params}"
  end

  def xml_query
    query_params = optin_value_hash.map {|k,v| "<column name='#{k}'>#{v}"}.join('</column>')
    "<?xml version='1.0' encoding='utf-8'?><creates><create user='ParentMedia'><table name='api_stg_registration_indirect'/><columns>#{query_params}</column></columns></create></creates>"
  end

  def query
    query_params = optin_value_hash.map {|k,v| "#{k}=#{v}"}.join('&')
    URI.encode "#{query_params}"
  end


  
  # finds the param with the name from the params 
  # but depends on where its a full page coreg or not
  def value(name)
    if self.params
      self.params[name]
    else
      param = self.coreg_optin_params.select {|p| p.name == name.to_s}.first
      param.try(:value) 
    end
  end

  # flat file formatted data row for flat file email output
  def  flat_file_row
    value_hash = optin_value_hash
    self.coreg.coreg_params.collect do |op|
      value = value_hash[op.name] || ''
      if op.flatfile_width.present?
        if op.flatfile_width > 0 # if width is zero, don't output ot the file'
          spaces = (op.flatfile_width - value.length)
          value + ' '* ((spaces >0)? spaces: 0)
        end
      else
        value + ','
      end
    end.join('')
  end

  def  sftp_flat_file_row(delimiter)
    value_hash = optin_value_hash
    self.coreg.coreg_params.collect do |op|
      value = value_hash[op.name] || ''
      if op.flatfile_width.present?
        if op.flatfile_width > 0 # if width is zero, don't output ot the file'
          spaces = (op.flatfile_width - value.length)
          value + ' '* ((spaces >0)? spaces: 0)
        end
      else
        value + ""
      end
    end.join(delimiter)
  end

  def current_endpoint
    (sent and !success and coreg.multistep?) ? coreg.endpoint2 : coreg.endpoint
  end

  private
  def optin_value_hash
    self.coreg.full_page? ? self.params : Hash[*self.coreg_optin_params.collect {|x| [x.name, x.value]}.flatten]
  end

  # for pre-submission filtering
  def acceptable?
    self.coreg.acceptance.present? ? eval(self.coreg.acceptance) : true
  end

  def successful?
    regex = self.coreg.success_regex
    return regex.nil? ? false : !Regexp.compile(Regexp.escape(regex)).match(self.response).nil?  
  end

end

