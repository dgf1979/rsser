class Feed < ActiveRecord::Base

  validates :rss, presence: true, uniqueness: true
  validates :title, presence: true
  has_many :items

  @@feed_logger ||= Logger.new("#{Rails.root}/log/feed.log")

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
    parser = parsed_feed.class.to_s

    feed_ojects = []

    case parser
    when "Feedjira::Parser::ITunesRSS"
      return feed_object_from_itunesrss(parsed_feed)
    when "Feedjira::Parser::RSSFeedBurner"
      return feed_object_from_rssfeedburner(parsed_feed)
    else
      puts "Unhandled or unknown parser type: #{parser}"
      binding.pry
    end

  end

  private
    # itunes RSS
    def feed_object_from_itunesrss(feed_object)
      errors = 0
      feed_object.entries.each do |entry|
        podcast_item_params = {
          mp3_url: entry.enclosure_url,
          title: entry.title,
          description: entry.try(:itunes_subtite),
          pub_date: entry.try(:published)
        }
        item = self.items.new(podcast_item_params)
        if self.items.where("title = ?", podcast_item_params[:title]).length == 0
          @@feed_logger.info "Found new items '#{podcast_item_params[:title]}' for feed '#{self.title}'"

          if item.save == false
            @@feed_logger.error "Failed to save '#{podcast_item_params[:title]}' for feed '#{self.title}'"

            errors += 1
            if errors == 1
              binding.pry
            end
          end
        else
          @@feed_logger.info "Skipping Existing item '#{podcast_item_params[:title]}' for feed '#{self.title}'"
        end
      end
      return errors
    end

    # feedburner RSS
    def feed_object_from_rssfeedburner(feed_object)
      errors = 0
      feed_object.entries.each do |entry|
        podcast_item_params = {
          mp3_url: entry.image,
          title: entry.title,
          description: entry.try(:summary),
          pub_date: entry.try(:published)
        }
        item = self.items.new(podcast_item_params)
        if item.save == false
          errors += 1
        end
      end
      return errors
    end

end
