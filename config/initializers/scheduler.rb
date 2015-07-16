require 'rufus-scheduler'

# Let's use the rufus-scheduler singleton
#
s = Rufus::Scheduler.singleton


# Stupid recurrent task...
#
s.every '1m' do

  Rails.logger.info "checking feeds at: #{Time.now}"
  Rails.logger.info "there are #{Feed.all.count} feeds"
end
