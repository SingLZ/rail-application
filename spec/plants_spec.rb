require "rails_helper"

RSpec.describe "Plants", type: :request do
  before do
    let!(:user) do
    # ensure no duplicate emails
    User.where(email: "test@example.com").destroy_all
    User.create!(
      first_name: "Test",
      last_name: "User",
      email: "test@example.com"
    )
  end

  describe "POST /plants" do
    it "creates a new plant" do
      expect {
        post plants_path, params: { plant: { 
          name: "Fern",
          species: "Boston Fern",
          location: "Living Room",
          watering_frequency: 7,
          last_watered_at: Time.now
          user: user
        } }
      }.to change(Plant, :count).by(1)

      follow_redirect!
      expect(response.body).to include("Plant was successfully created")
    end
  end

  describe "PATCH /plants/:id" do
    let!(:user) { User.create!(first_name: "Test", last_name: "User", email: "test2@example.com") }
    let!(:plant) { Plant.create!(name: "Cactus", species: "Succulent", location: "Window", user: user) }

    it "updates the plant" do
      patch plant_path(plant), params: { plant: { location: "Desk" } }
      plant.reload
      expect(plant.location).to eq("Desk")
    end
  end
end
