require "rails_helper"

RSpec.describe "Plants", type: :request do
  describe "POST /plants" do
    it "creates a new plant and user if needed" do
      User.where(email: "test@example.com").destroy_all
      expect {
        post plants_path, params: {
          plant: {
            name: "Fern",
            species: "Boston Fern",
            location: "Living Room",
            watering_frequency: 7,
            last_watered_at: Time.current,
            user_name: "Test User",
            user_email: "test@example.com"
          }
        }
      }.to change(Plant, :count).by(1)
       .and change(User, :count).by(1)

      follow_redirect!
      expect(response.body).to include("added by: Test User")
    end
  end

  describe "PATCH /plants/:id" do
    let!(:user) { User.create!(first_name: "Test", last_name: "User", email: "test2@example.com") }
    let!(:plant) do
  Plant.create!(
    name: "Cactus",
    species: "Succulent",
    location: "Window",
    watering_frequency: 7,  # <-- required field
    user: user
  )
end


    it "updates the plant" do
      patch plant_path(plant), params: { plant: { location: "Desk" } }
      plant.reload
      expect(plant.location).to eq("Desk")
    end
  end
end
