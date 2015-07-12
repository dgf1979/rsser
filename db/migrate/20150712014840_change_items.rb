class ChangeItems < ActiveRecord::Migration
  def change
    change_column :items, :donewith, :boolean, :default => false
  end
end
