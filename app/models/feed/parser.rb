Module Feed::Parser

  

end


#
# feed = Feedjira::Feed.fetch_and_parse(@feed.rss)
# feed.entries.each do |entry|
#   if entry.enclosure_url
#     podcast_item_params = {
#       mp3_url: entry.enclosure_url,
#       title: entry.title,
#       description: entry.try(:description).try(:summary).try(:itunes_subtitle),
#       pub_date: entry.try(:pubDate).try(:published)
#     }
#     item = @feed.items.new(podcast_item_params)
#     last_result = item.save
#   end
# end
