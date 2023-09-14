class CreateLivingSocialCities < ActiveRecord::Migration
  def self.up
    create_table :living_social_cities do |t|
      t.integer :city_id
      t.string :displayName
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end

  def self.down
    drop_table :living_social_cities
  end
end
