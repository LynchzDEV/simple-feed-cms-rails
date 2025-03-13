class FeedItem < ApplicationRecord
  belongs_to :feedable, polymorphic: true

  scope :latest_first, -> { order(published_at: :desc) }
end

class Post < ApplicationRecord
  has_one :feed_item, as: :feedable, dependent: :destroy

  validates :title, presence: true
  validates :content, presence: true

  after_create :create_feed_item

  private

  def create_feed_item
    FeedItem.create(feedable: self, published_at: Time.current)
  end
end
