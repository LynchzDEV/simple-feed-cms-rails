class FeedController < ApplicationController
  def index
    @feed_items = FeedItem.includes(:feedable).order(published_at: :desc)

    if params[:type].present?
      @feed_items = @feed_items.where(feedable_type: params[:type].classify)
    end

    @feed_items = @feed_items.page(params[:page]).per(12)
  end
end
