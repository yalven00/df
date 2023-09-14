class Coreg < ActiveRecord::Base
  has_many :coreg_params, :order => 'sequence ASC'
  has_many :coreg_optins 
  has_many :page_coregs
  has_many :pages, :through => :page_coregs
  mount_uploader :image, ImageUploader
  accepts_nested_attributes_for :coreg_params
  validates :email_field, :presence => true

  scope :active, includes(:pages).where('pages.id IS NOT NULL')
  scope :email_file, where("flatfile_pattern IS NOT NULL")  
  scope :available_to_email, lambda { |email|
    includes(:coreg_optins).where("coreg_optins.email IS NULL OR coreg_optins.email <> ?", email).active
  }
  scope :taken_by_email, lambda { |email|
    includes(:coreg_optins).where("coreg_optins.email = ?", email).active
  }

  scope :compact, where('coreg_type <> "full_page"')
  scope :full_pages, active.where(:coreg_type => 'full_page').order('coregs.id')
  
  def opt_out?
    self.taken_default=="true"
  end
  
  def post?
    self.request_method == 'post'
  end

  def get?
    self.request_method == 'get'
  end

  def xml?
    self.request_method == 'xml'
  end

  def sftp?
    self.request_method == 'sftp'
  end

  def ftp?
    self.request_method == 'ftp'
  end

  def full_page?
    self.coreg_type == 'full_page'
  end

  def email_file?
    self.flatfile_pattern.present?
  end

  def email_file_name
    @email_file_name ||= (eval flatfile_pattern)
  end

  def run_today?
    if run_days.present?
      run_days.split(' ').map(&:to_i).include? Time.new.wday
    else
      false
    end
  end
  
  def expired?
  if expires_on !=nil && Time.now.strftime('%Y%m%d%H%M%S') > expires_on.strftime('%Y%m%d%H%M%S') 
    true 
  else
    false
  end
  end

  # if the coreg has mutli steps
  # based on the 2 fields
  def multistep?
    endpoint2 and endpoint2_delay 
  end
end
