# spec/plants_spec.rb
require "rails_helper"

RSpec.describe "Plants (HTML flow)", type: :request do
  def sign_in!(email:, password:)
    post "/session", params: { email:, password: } # HTML request
    expect([200, 204, 302, 303]).to include(response.status)
    follow_redirect! if response.redirect?
  end

  let!(:user) do
    u = User.find_or_initialize_by(email: "htmlspec@example.com")
    u.first_name = "HTML"
    u.last_name  = "Spec"
    u.password   = "password123"
    u.save!
    u
  end

  describe "POST /plants" do
    it "creates a new plant for an authenticated user only" do
      sign_in!(email: user.email, password: "password123")

      expect {
        post plants_path, params: {
          plant: {
            name: "HTML Spec Plant",
            species: "Succulent",
            location: "Desk",
            watering_frequency: 5,
            last_watered_at: Time.current
          }
        }
      }.to change(Plant, :count).by(1)

      # HTML branch redirects to index
      expect(response).to have_http_status(:found).or have_http_status(:see_other).or have_http_status(:ok)
      follow_redirect! if response.redirect?
      expect(request.path).to eq(plants_path)
    end

    it "does not allow unauthenticated user to create a plant" do
      expect {
        post plants_path, params: {
          plant: {
            name: "Unauthorized Plant",
            species: "Fake",
            location: "Nowhere",
            watering_frequency: 3,
            last_watered_at: Time.current
          }
        }
      }.not_to change(Plant, :count)

      # Unauthed HTML requests are redirected to login
      expect(response).to have_http_status(:found).or have_http_status(:see_other)
      follow_redirect! if response.redirect?
      expect(request.path).to eq(new_session_path)
    end
  end
end
