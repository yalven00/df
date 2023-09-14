class Page < ActiveRecord::Base
  validates_uniqueness_of :name
  has_many :page_coregs
  has_many :coregs, :through => :page_coregs

  def adjusted_coregs
    include_all_coregs? ? Coreg.compact.active : self.coregs
  end

  private
  def include_all_coregs?
    name == 'dfm_hotdeals'
  end
end
