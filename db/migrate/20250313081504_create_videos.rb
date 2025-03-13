class CreateVideos < ActiveRecord::Migration[8.0]
  def change
    create_table :videos do |t|
      t.string :title
      t.text :content
      t.string :file

      t.timestamps
    end
  end
end
