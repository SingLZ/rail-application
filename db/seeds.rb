# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# db/seeds.rb
# db/seeds.rb

require 'faker'

# Create a test user
user = User.first || User.create!(email: "test@example.com", password: "password")

# Create 10 random plants
10.times do
  Plant.create!(
    user: user,
    name: Faker::Creature::Animal.name,
    species: ["Succulent", "Fern", "Orchid", "Cactus"].sample,
    location: ["Living Room", "Kitchen", "Balcony"].sample,
    watering_frequency: rand(3..14),
    last_watered_at: rand(0..10).days.ago
  )
end
