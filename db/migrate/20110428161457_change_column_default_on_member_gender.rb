class ChangeColumnDefaultOnMemberGender < ActiveRecord::Migration
  def self.up
		change_column_default(:members, :gender, 'F')
  end

  def self.down
		change_column_default(:members, :gender, 'F')
		# Can't change it back to NULL
		# Sets a new default value for a column. If you want to set the default value to NULL, you are out of luck. You need to DatabaseStatements#execute the appropriate SQL statement yourself.
		# http://apidock.com/rails/v3.0.5/ActiveRecord/ConnectionAdapters/SchemaStatements/change_column_default
  end
end
