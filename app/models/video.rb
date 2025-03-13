class Video < ApplicationRecord
  after_create :create_feed_item

  private

  def create_feed_item
    FeedItem.create(
      feedable: self,
      published_at: created_at
    )
  end
end
