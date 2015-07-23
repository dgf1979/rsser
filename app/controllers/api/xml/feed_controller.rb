class Api::Xml::FeedController < ApplicationController

  def index
    @items = Item.current
    respond_to do |format|
      format.xml  # index.builder
    end
  end

end
