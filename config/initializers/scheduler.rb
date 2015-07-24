require 'rufus-scheduler'

s = Rufus::Scheduler.singleton

s.every '10m' do
  Feed.all.each do |f|
    Rails.logger.info "checking feed #{f.title} for updates at: #{Time.now}"
    f.fetch_new_items
    sleep(5)
  end
end
