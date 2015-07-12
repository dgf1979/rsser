class FeedsController < ApplicationController
  before_action :set_feed, only: [:show, :edit, :update, :destroy, :refresh]

  # GET /feeds
  # GET /feeds.json
  def index
    @feeds = Feed.all
  end

  # GET /feeds/1
  # GET /feeds/1.json
  def show
  end

  # GET /feeds/new
  def new
    @feed = Feed.new
  end

  # GET /feeds/1/edit
  def edit
  end

  # POST /feeds
  # POST /feeds.json
  def create
    rss = feed_params["rss"]
    feed = Feedjira::Feed.fetch_and_parse(rss)

    new_feed_params = {
      rss: rss,
      description: feed.description,
      link: feed.url,
      title: feed.title
    }
    @feed = Feed.new(new_feed_params)

    respond_to do |format|
      if @feed.save
        format.html { redirect_to @feed, notice: 'Feed was successfully created.' }
        # format.json { render :show, status: :created, location: @feed }
      else
        # format.html { render :new }
        # format.json { render json: @feed.errors, status: :unprocessable_entity }
      end
    end
  end

  def refresh
    feed = Feedjira::Feed.fetch_and_parse(@feed.rss)
    feed.entries.each do |entry|
      if entry.enclosure_url
        podcast_item_params = {
          mp3_url: entry.enclosure_url,
          title: entry.title,
          description: entry.try(:description).try(:summary).try(:itunes_subtitle),
          pub_date: entry.try(:pubDate).try(:published)
        }
        item = @feed.items.new(podcast_item_params)
        last_result = item.save
      end
    end

    redirect_to @feed
  end

  # PATCH/PUT /feeds/1
  # PATCH/PUT /feeds/1.json
  def update
    respond_to do |format|
      if @feed.update(feed_params)
        format.html { redirect_to @feed, notice: 'Feed was successfully updated.' }
        format.json { render :show, status: :ok, location: @feed }
      else
        format.html { render :edit }
        format.json { render json: @feed.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /feeds/1
  # DELETE /feeds/1.json
  def destroy
    @feed.destroy
    respond_to do |format|
      format.html { redirect_to feeds_url, notice: 'Feed was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_feed
      @feed = Feed.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def feed_params
      params.require(:feed).permit(:rss, :description, :link, :title)
    end
end
