# spec/requests/dashboard_spec.rb
require 'rails_helper'

RSpec.describe "Dashboard", type: :request do
  def sign_in!(email:, password:)
    post "/session", params: { email:, password: }
    # HTML flow redirects after login; allow 302/303 too
    expect([200, 204, 302, 303]).to include(response.status)
    follow_redirect! if response.redirect?
  end

  describe "GET /dashboard" do
    let!(:user) do
      user = User.find_or_initialize_by(email: "test@example.com")
      user.first_name = "Test"
      user.last_name  = "User"
      user.password   = "password123"
      user.save!
      user
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

    context "when unauthenticated" do
      it "redirects to login" do
        get dashboard_path
        expect(response).to have_http_status(:found).or have_http_status(:see_other)
        # Optional: assert it lands on the login page
        follow_redirect!
        expect(request.path).to eq(new_session_path)
      end
    end

    context "when authenticated" do
      before { sign_in!(email: user.email, password: "password123") }

      it "returns a successful response" do
        get dashboard_path
        expect(response).to have_http_status(:ok)
      end

      it "includes names/count of plants that need watering" do
  get dashboard_path
  doc = Nokogiri::HTML(response.body)
  text = doc.at_css('.dashboard-summary')&.text&.squish
  expect(text).to include("Needs Watering Today: 0")
end

    end
  end
end
