class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :update]

  def show
  end

  def update
  end

  private
    def set_item
      @item = Item.find(params[:id])
    end
end
