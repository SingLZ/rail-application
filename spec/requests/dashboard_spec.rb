# spec/requests/dashboard_spec.rb
require 'rails_helper'

RSpec.describe "Dashboard", type: :request do
  def sign_in!(email:, password:)
    post "/session", params: { email:, password: }
    expect([200, 204, 302]).to include(response.status)
  end

  describe "GET /dashboard" do
    let!(:user) do
      user = User.find_or_initialize_by(email: "test@example.com")
      user.first_name = "Test"
      user.last_name  = "User"
      user.password   = "password123"   # ensure password_digest exists
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
      it "blocks access" do
        get dashboard_path
        expect(response).to have_http_status(:forbidden).or have_http_status(:not_found)
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
        expect(response.body).to include("0 plants need watering today")
      end
    end
  end
end
