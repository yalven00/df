class AddPagesTable < ActiveRecord::Migration
  def self.up
    create_table :content_pages do |t|
      t.string     :title
      t.string     :nav_title
      t.string     :path
      t.string     :meta_title
      t.string     :meta_description
      t.string     :meta_keywords
      t.text       :body     
      t.timestamps
    end
  end

  def self.down
    drop_table :pages
  end
end

