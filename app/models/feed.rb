class Feed < ActiveRecord::Base
  validates :rss, presence: true
  validates :title, presence: true
  has_many :items
end
