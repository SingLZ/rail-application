require 'rails_helper'

RSpec.describe "Plants", type: :request do
  before do
    @user = User.create!(email: "test@example.com", password: "password")
    @plant = Plant.create!(
      user: @user,
      name: "Test Plant",
      species: "Fern",
      location: "Living Room",
      watering_frequency: 7,
      last_watered_at: Time.now
    )
  end

  describe "GET /plants" do
    it "returns a successful response" do
      get plants_path
      expect(response).to have_http_status(:ok)
    end

    it "includes plant names in the response body" do
      get plants_path
      expect(response.body).to include(@plant.name)
    end
  end

  describe "GET /plants/:id" do
    it "returns a successful response" do
      get plant_path(@plant)
      expect(response).to have_http_status(:ok)
    end

    it "shows the plant name on the page" do
      get plant_path(@plant)
      expect(response.body).to include(@plant.name)
    end
  end

  describe "GET /plants/new" do
    it "returns a successful response" do
      get new_plant_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /plants/:id/edit" do
    it "returns a successful response" do
      get edit_plant_path(@plant)
      expect(response).to have_http_status(:ok)
    end
  end
end
