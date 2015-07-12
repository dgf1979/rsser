json.array!(@feeds) do |feed|
  json.extract! feed, :id, :rss, :description, :link, :title
  json.url feed_url(feed, format: :json)
end
