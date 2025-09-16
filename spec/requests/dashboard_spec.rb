require 'rails_helper'

RSpec.describe "Dashboard", type: :request do
  describe "GET /dashboard" do
    # create a user for the plant
    let!(:user) { User.create!(email: "test@example.com", password: "password") }

    # create a plant that belongs to that user
    let!(:plant) do
      Plant.create!(
        user: user,
        name: "Test Plant",
        species: "Cactus",
        location: "Balcony",
        watering_frequency: 3,
        last_watered_at: 5.days.ago
      )
    end

    it "returns a successful response" do
      get dashboard_path
      expect(response).to have_http_status(:ok)
    end

    it "includes names of plants that need watering" do
      get dashboard_path
      expect(response.body).to include(plant.name)
    end
  end
end

