class Feed < ActiveRecord::Base
  default_scope { order('title ASC') }
  validates :rss, presence: true, uniqueness: true
  validates :title, presence: true
  has_many :items

  include FeedsHelper

  @@feed_logger ||= Logger.new("#{Rails.root}/log/feed.log")

  def catch_up(number) # mark all but the x most recent items done
    current_items = self.items.where(donewith: false).order('pub_date DESC')
    if (current_items.count - number >= 0)
      remove_items = current_items.last(current_items.count - number)
      remove_items.each do |remove_item|
        Item.find(remove_item.id).update(donewith: true)
      end
    end
  end

  def self.from_rss_uri(rss_xml_uri)
    feed = Feedjira::Feed.fetch_and_parse(rss_xml_uri)
    new_feed_params = {
      rss: rss_xml_uri,
      description: feed.description,
      link: feed.url,
      title: feed.title
    }
    return Feed.new(new_feed_params)
  end

  def fetch_new_items
    parsed_feed = Feedjira::Feed.fetch_and_parse(self.rss)

    errors = 0

    parsed_feed.entries.each do |entry|
      mp3_url = fetch_first_matching(entry, [:image, :enclosure_url])
      if mp3_url
        podcast_item_params = {
          mp3_url: mp3_url,
          title: entry.title,
          description: fetch_first_matching(entry, [:summary, :itunes_subtitle, :description, :itunes_summary]),
          pub_date: fetch_first_matching(entry, [:published, :pubDate])
        }
        item = self.items.new(podcast_item_params)

        if self.items.where("title = ?", podcast_item_params[:title]).length == 0
          @@feed_logger.info "Found new items '#{podcast_item_params[:title]}' for feed '#{self.title}'"
          if item.save == false
            @@feed_logger.error "Failed to save '#{podcast_item_params[:title]}' for feed '#{self.title}'"
            errors += 1
          end
        else
          @@feed_logger.info "Skipping Existing item '#{podcast_item_params[:title]}' for feed '#{self.title}'"
        end

      else
        @@feed_logger.info "Entry with no MP3 content"
      end

    end

    return errors
  end

end
