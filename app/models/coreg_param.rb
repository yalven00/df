class CoregParam < ActiveRecord::Base
  belongs_to :coreg
  #validates_presence_of :field_type
  accepts_nested_attributes_for :coreg

  has_one :dependee, :class_name => 'CoregParam', :foreign_key => 'dependent_id'

  belongs_to :dependent, :class_name => 'CoregParam', :foreign_key => 'dependent_id'

  has_one :parent, :class_name => 'CoregParam', :foreign_key => 'group_id'

  has_many :children, :class_name => 'CoregParam', :foreign_key => 'group_id'
  
  scope :top_level, where('group_id is NULL')

  def displayable?
    self.display
  end

  # for the phamton fields that retrieve its value from the other existing fields
  def virtual?
    !self.display && self.match?
  end

  # if a field has a match value
  def match?
    !self.match.blank?
  end

  # if a field should be on screen
  def on_screen?
    self.displayable? || self.match?
  end

  def matches
    @matches ||= match_element_ids.collect {|id| "$('##{id}')"}
  end

  def first_match
    "##{match_element_ids.first}"
  end

  private
  def match_element_ids
    self.match? ?  self.match.scan(/\$\(\'#(\w*)\'/).flatten.uniq : []
  end
  
  def spawn_children_params
    return unless ['checkbox_group', 'radio_group'].include?(self.field_type) && self.select_options.present? 
    self.select_options.split(',').each do |child_text|
      item_options = child_text.split(':')
      self.children.create! :coreg_id => self.coreg_id,
                          :name => item_options[2],
                          :label => item_options[0],
                          :value => item_options[1],
                          :display => true
    end
  end
end
