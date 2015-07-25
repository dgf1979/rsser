class FeedsController < ApplicationController
  before_action :set_feed, only: [:show, :edit, :update, :destroy, :refresh, :catchup]

  def index
    @feeds = Feed.all
  end

  def show
  end

  def new
    @feed = Feed.new
  end

  def bulkload
    #parse and load
    string_to_parse = params[:bulkdata]
    uris = string_to_parse.scan(/xmlUrl="https?:\S*"{1}/)
    uris.each do |uri|
      uri = uri.split('"')[1]
      if (uri =~ URI::regexp(%w(https http)))
        feed = Feed.from_rss_uri(uri)
        if feed
          feed.save
        end
      end
    end
    flash[:notice] = 'Feeds parsed and loaded.'
    render 'feeds/new_bulkload'
  end

  def catchup
    @feed.catch_up(4)
    redirect_to @feed
  end

  def edit
  end

  def create

    begin
      if (feed_params["rss"] =~ URI::regexp(%w(https http))) == nil
        raise "Invalid URL"
      end
    rescue Exception => e
      @exception = e
      @feed = Feed.new
      return render :new
    end

    @feed = Feed.from_rss_uri(feed_params["rss"])

    respond_to do |format|
      if @feed.save
        format.html { redirect_to @feed, notice: 'Feed was successfully created.' }
      else
        format.html { render :new }
      end
    end

  end

  def refresh
    @feed.fetch_new_items

    redirect_to @feed
  end

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
