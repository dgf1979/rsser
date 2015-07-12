class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :mp3_url
      t.string :title
      t.string :description
      t.string :enclosure
      t.datetime :pub_date
      t.integer :feed_id
      t.boolean :donewith

      t.timestamps null: false
    end
  end
end
