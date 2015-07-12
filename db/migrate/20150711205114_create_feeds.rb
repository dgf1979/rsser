class CreateFeeds < ActiveRecord::Migration
  def change
    create_table :feeds do |t|
      t.string :rss
      t.string :description
      t.string :link
      t.string :title

      t.timestamps null: false
    end
  end
end
