class Item < ActiveRecord::Base
  validates :mp3_url, presence: true
  validates :feed_id, presence: true
  belongs_to :feed
end
