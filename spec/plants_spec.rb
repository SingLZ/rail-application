require "rails_helper"

RSpec.describe "Plants", type: :request do
  def sign_in!(email:, password:)
    post "/session", params: { email:, password: }
    expect([200, 204]).to include(response.status)
  end

  describe "POST /plants" do
    it "creates a new plant for an authenticated user only" do
      user = User.create!(
        first_name: "Test", last_name: "User",
        email: "test1@example.com", password: "password123"
      )


      sign_in!(email: user.email, password: "password123")

      expect {
        post plants_path, params: {
          plant: {
            name: "Fern",
            species: "Boston Fern",
            location: "Living Room",
            watering_frequency: 7,
            last_watered_at: Time.current
          }
        }
      }.to change(Plant, :count).by(1)
      expect { }.not_to change(User, :count) # explicit no-op expectation

      plant = Plant.order(:created_at).last
      expect(plant.user).to eq(user)
      expect(response).to have_http_status(:created).or have_http_status(:ok)
    end

    it "does not allow unauthenticated user to create a plant" do
      post plants_path, params: {
        plant: {
          name: "Unauthorized Plant",
          species: "Fake",
          location: "Nowhere",
          watering_frequency: 3,
          last_watered_at: Time.current,
        }
      }
      expect(response).to have_http_status(:forbidden).or have_http_status(:not_found)
      expect(Plant.where(name: "Unauthorized Plant")).to be_empty
    end
  end
end   # ← closes the outer RSpec.describe
