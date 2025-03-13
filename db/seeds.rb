# db/seeds.rb
require 'faker'

# Clear existing data
puts "Clearing existing data..."
Post.destroy_all
Video.destroy_all
News.destroy_all
FeedItem.destroy_all

puts "Creating content..."

post_data = []
video_data = []
news_data = []

# Prepare 20 posts
20.times do |i|
  post_data << {
    title: "#{Faker::ProgrammingLanguage.name} Tutorial #{i+1}: #{Faker::Hacker.say_something_smart}",
    content: Faker::Lorem.paragraphs(number: rand(2..4)).join("\n\n")
  }
end

# Prepare 20 videos
video_topics = ['Ruby Basics', 'Rails Models', 'ActiveRecord', 'API Development',
                'Testing in Rails', 'JavaScript Integration', 'Deployment', 'Database Optimization']

20.times do |i|
  topic = video_topics[i % video_topics.length]
  duration = rand(5..45)

  video_data << {
    title: "Video Tutorial: #{topic} - Part #{i+1}",
    content: "This #{duration}-minute video covers essential concepts about #{topic}. #{Faker::Lorem.paragraph(sentence_count: 3)}",
    file: "videos/#{topic.parameterize}_#{i+1}.mp4"
  }
end

# Prepare 20 news items
news_sources = ['RubyWeekly', 'Rails Blog', 'GitHub Blog', 'Dev.to', 'Medium', 'HackerNews']

20.times do |i|
  source = news_sources[i % news_sources.length]

  news_data << {
    title: "#{Faker::Company.catch_phrase}: #{Faker::Hacker.say_something_smart}",
    content: Faker::Lorem.paragraphs(number: rand(1..3)).join("\n\n"),
    reference: "https://#{source.downcase.gsub(/\s+/, '')}.com/articles/#{Faker::Internet.slug}"
  }
end

# Function to create a record with specified time
def create_with_time(klass, data, time)
  # Create the record
  record = klass.create!(data)

  # Update timestamps
  record.update_columns(created_at: time, updated_at: time)

  # Create feed item
  FeedItem.create!(
    feedable: record,
    published_at: time,
    created_at: time,
    updated_at: time
  )

  return record
end

# Now create all content in a randomized order
# Start with a base time of 30 days ago
base_time = 30.days.ago

# Create a timeline of events by randomly selecting content types
all_content = []

# Add all content to a single array with type information
post_data.each { |data| all_content << { type: 'Post', data: data } }
video_data.each { |data| all_content << { type: 'Video', data: data } }
news_data.each { |data| all_content << { type: 'News', data: data } }

# Shuffle the array to randomize the order of content
all_content.shuffle!

# Create each piece of content with a staggered timestamp
puts "Creating timeline with mixed content types..."
all_content.each_with_index do |content, index|
  # Calculate a somewhat random time
  # This adds between 5 and 15 hours for each piece of content
  current_time = base_time + (index * rand(5..15)).hours

  case content[:type]
  when 'Post'
    create_with_time(Post, content[:data], current_time)
    puts "Created Post at #{current_time}"
  when 'Video'
    create_with_time(Video, content[:data], current_time)
    puts "Created Video at #{current_time}"
  when 'News'
    create_with_time(News, content[:data], current_time)
    puts "Created News at #{current_time}"
  end
end

# Verify creation
puts "Seed data created successfully!"
puts "Created #{Post.count} posts, #{Video.count} videos, and #{News.count} news items."
puts "Total feed items: #{FeedItem.count}"

# Check associations and distribution
feed_item_counts = {
  'Post' => FeedItem.where(feedable_type: 'Post').count,
  'Video' => FeedItem.where(feedable_type: 'Video').count,
  'News' => FeedItem.where(feedable_type: 'News').count
}
puts "Feed item breakdown: #{feed_item_counts}"

# Check the chronological spread
oldest = FeedItem.order(published_at: :asc).first
newest = FeedItem.order(published_at: :asc).last
puts "Timeline spans from #{oldest.published_at} to #{newest.published_at}"
