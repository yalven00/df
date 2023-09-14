# this class emulates the mysql2 Date column for the date fields

class CoregOptinParamDateColumn

  def self.klass
    Date
  end

  def self.number?
    false
  end

  def self.type_cast(value)
    value
  end
end
