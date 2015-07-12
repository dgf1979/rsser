class Item < ActiveRecord::Base
  validates :mp3_url, presence: true
  validates :feed_id, presence: true
  validates :title, presence: true, uniqueness: { scope: :feed,
                    message: "item title already taken for this feed" }
  belongs_to :feed

  def self.current
    Item.where(donewith: :false)
  end
end
