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

puts "Cleaning database..."
Bookmark.destroy_all
List.destroy_all
Movie.destroy_all

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

classics_list = List.find_or_create_by!(name: "Test List") do |list|
  list.is_public = true
end

shawshank = Movie.find_by(title: "The Shawshank Redemption")
godfather = Movie.find_by(title: "The Godfather")
schindlers = Movie.find_by(title: "Schindler's List")

Bookmark.find_or_create_by!(list: classics_list, movie: shawshank) do |bookmark|
  bookmark.comment = "My all-time favorite!"
end

Bookmark.find_or_create_by!(list: classics_list, movie: godfather) do |bookmark|
  bookmark.comment = "A masterpiece of filmmaking."
end

Bookmark.find_or_create_by!(list: classics_list, movie: schindlers) do |bookmark|
  bookmark.comment = "A truly moving and important film."
end

puts "Created #{Movie.count} movies."
puts "Created #{List.count} list and #{Bookmark.count} bookmarks."
