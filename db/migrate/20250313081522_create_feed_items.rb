class CreateFeedItems < ActiveRecord::Migration[8.0]
  def change
    create_table :feed_items do |t|
      t.references :feedable, polymorphic: true, null: false
      t.datetime :published_at

      t.timestamps
    end
  end
end
