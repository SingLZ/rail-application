require 'rails_helper'

RSpec.describe "Dashboard", type: :request do
  describe "GET /dashboard" do
    let!(:user) do
      User.find_or_create_by!(email: "test@example.com") do |u|
        u.first_name = "Test"
        u.last_name  = "User"
      end
    end
    # create a plant
    let!(:plant) do
      Plant.create!(
        name: "Test Plant",
        species: "Fern",
        location: "Living Room",
        watering_frequency: 7,
        last_watered_at: Time.now,
        user: user
      )
    end

    it "returns a successful response" do
      get dashboard_path
      expect(response).to have_http_status(:ok)
    end

    it "includes names of plants that need watering" do
      get dashboard_path
      expect(response.body).to include("0 plants need watering today")
    end
  end
end
