class ItemsController < ApplicationController
  before_action :set_feed, only: [:show, :update]
  before_action :set_item, only: [:show, :update]

  def show
  end

  def update
    respond_to do |format|
      if @item.update({ donewith: params[:donewith] })
        format.js {}
        #format.html redirect_to feed_path(@feed)
      end
    end
  end

  private
    def set_item
      @item = Item.find(params[:id])
    end
    def set_feed
      @feed = Feed.find(params[:feed_id])
    end

end
