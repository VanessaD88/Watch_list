# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require "json"
require "open-uri"
require 'faker'

puts "Cleaning database..."
Bookmark.destroy_all
List.destroy_all
Movie.destroy_all
User.destroy_all

# Creating movies
puts "Fetching top-rated movies from Le Wagon TMDB proxy..."
url = "https://tmdb.lewagon.com/movie/top_rated"
movies_serialized = URI.open(url).read
movies = JSON.parse(movies_serialized)

puts "Creating movies..."
movies["results"].each do |movie_data|
  Movie.create!(
    title: movie_data["title"],
    overview: movie_data["overview"],
    poster_url: "https://image.tmdb.org/t/p/w500#{movie_data['poster_path']}",
    rating: movie_data["vote_average"]
  )
end

puts "Created #{Movie.count} movies."

# Creating 5 users
puts "Creating users..."
5.times do
  User.create!(
    email: Faker::Internet.unique.email,
    password: "password", # Devise will handle encryption
    password_confirmation: "password"
  )
end
puts "Created #{User.count} users."

# Creating Lists
puts "Creating lists and bookmarks..."
users = User.all
movies = Movie.all
list_names = ["Favorites", "Watch Later", "Comedies", "Drama Lovers", "Top Rated", "Feel Good"]

users.each do |user|
  rand(2..4).times do
    list = List.create!(
      name: list_names.sample,
      description: Faker::Lorem.sentence(word_count: 8),
      is_public: [true, false].sample,
      user: user
    )

    # Add some movies from the existing Movie db
    sample_movies = movies.sample(rand(3..7))
    sample_movies.each do |movie|
      Bookmark.create!(
        list: list,
        movie: movie,
        comment: Faker::Movie.quote
      )
    end
  end
end

puts "Created #{List.count} lists and #{Bookmark.count} bookmarks."
