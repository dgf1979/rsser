xml.instruct!
xml.rss("version" => "2.0", "xmlns:atom" => "http://www.w3.org/2005/Atom") do
  xml.channel do
    xml.title "RSSer Podcast Feed"
    xml.description "All podcasts that have not been cleared out of RSSer"
    xml.link request.original_url

    xml.tag!("atom:link", {"href" => request.original_url, "rel" => "self", "type" => "application/rss+xml"})

    @items.each do |item|

      xml.item do
        xml.title ActionController::Base.helpers.strip_tags(item.feed.title + " - " + item.title)
        xml.description ActionController::Base.helpers.strip_tags(item.description)
        xml.pubDate item.pub_date.httpdate
        xml.enclosure("url" => item.mp3_url, "type" => "audio/mpeg3", "length" => "0")
      end

    end

  end

end
