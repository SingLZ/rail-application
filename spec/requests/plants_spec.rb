require 'rails_helper'

RSpec.describe "Plants", type: :request do
  def sign_in!(email:, password:)
    post "/session", params: { email:, password: }
    expect([200, 204, 302]).to include(response.status)
  end

  let!(:user) do
  u = User.find_or_initialize_by(email: "test@example.com")
  u.first_name = "Test"
  u.last_name  = "User"
  u.password   = "password123"   # ensure password_digest exists
  u.save!
  u
end


  let!(:plant) do
    Plant.create!(
      name: "Test Plant",
      species: "Fern",
      location: "Living Room",
      watering_frequency: 7,
      last_watered_at: Time.current,
      user: user
    )
  end

  describe "GET /plants" do
    it "returns a successful response (public)" do
      get plants_path
      expect(response).to have_http_status(:ok)
    end

    it "includes plant names in the response body" do
      get plants_path
      expect(response.body).to include(plant.name)  
    end
  end

  describe "GET /plants/:id" do
    it "returns a successful response (public)" do
      get plant_path(plant)
      expect(response).to have_http_status(:ok)
    end

    it "shows the plant name on the page/body" do
      get plant_path(plant)
      expect(response.body).to include(plant.name)
    end
  end

  describe "GET /plants/new" do
    context "when unauthenticated" do
      it "blocks access" do
        get new_plant_path
        expect(response).to have_http_status(:forbidden).or have_http_status(:not_found)
      end
    end

    context "when authenticated" do
      before { sign_in!(email: user.email, password: "password123") }

      it "returns a successful response" do
        get new_plant_path
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "GET /plants/:id/edit" do
    context "when unauthenticated" do
      it "blocks access" do
        get edit_plant_path(plant)
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
