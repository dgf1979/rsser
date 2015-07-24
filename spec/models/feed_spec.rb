require 'rails_helper'

describe Feed do
  it { should validate_presence_of :rss }
  it { should validate_presence_of :title }
  it { should have_many :items }
end

describe "Feed.from_rss_uri" do
  it "creates a new feed object given an RSS feed url", :vcr => true do
    uri = "http://feeds.feedburner.com/talpodcast"
    feed = Feed.from_rss_uri(uri)
    expect(feed.rss).to(eql(uri))
  end
end

describe "Feed#fetch_new_items" do
  it "load all podcast items from a feed", :vcr => true  do
    feed = Feed.create( rss: "http://feeds.feedburner.com/talpodcast",
      link: "http://www.thisamericanlife.org",
      title: "This American Life",
      description: "Dummy description" )
    feed.fetch_new_items
    expect(feed.items.all.count).to(satisfy("be greater than 0") { |v| v > 0 })
  end
end

describe "Feed#catch_up" do
  it "remove (i.e. mark as :downwith) the X-number oldest items from the feed" do
    feed = Feed.create( rss: "http://feeds.feedburner.com/talpodcast",
    link: "http://www.thisamericanlife.org",
    title: "This American Life",
    description: "Dummy description" )

    oldest = feed.items.create( mp3_url: "http://somefakeplace.com/file.mp3",
      title: "oldest",
      pub_date: "Thu, 18 Dec 2014 10:30:00 +0000")
    old = feed.items.create( mp3_url: "http://somefakeplace.com/file.mp3",
      title: "old",
      pub_date: "Thu, 19 Dec 2014 10:30:00 +0000")
    newer = feed.items.create( mp3_url: "http://somefakeplace.com/file.mp3",
      title: "newer",
      pub_date: "Thu, 28 Dec 2014 10:30:00 +0000")
    newest = feed.items.create( mp3_url: "http://somefakeplace.com/file.mp3",
      title: "newest",
      pub_date: "Thu, 29 Dec 2014 10:30:00 +0000")

    feed.catch_up(2)
    expect(feed.items.find(old.id).donewith).to eql(true)
  end
end
