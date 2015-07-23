xml.instruct!
xml.rss do
  xml.channel do
    xml.title "RSSer Podcast Feed"
    xml.description "All podcasts that have not been cleared out of RSSer"

    @items.each do |item|

      xml.item do
        xml.title item.feed.title + " - " + item.title
        xml.description item.description
        xml.pubDate item.pub_date
        xml.enclosure("url" => item.mp3_url)
      end

    end

  end

end
