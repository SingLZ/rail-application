# spec/requests/authentication_spec.rb
require "rails_helper"

RSpec.describe "Authentication / Access Control", type: :request do
  let!(:user) do
    User.create!(
      first_name: "Test", last_name: "User",
      email: "plantuser@example.com", password: "password123"
    )
  end
  let!(:plant_record) do
    Plant.create!(
      name: "Fern",
      species: "Boston Fern",
      location: "Living Room",
      watering_frequency: 7,
      user: user
    )
  end

  def sign_in!(email:, password:)
    post "/session", params: { email:, password: }
    expect([200, 204, 302]).to include(response.status)
  end

  context "public endpoints" do
    it "allows GET /plants (public index)" do
      get '/plants'
      expect(response).to have_http_status(:ok)
    end

    it "allows GET /plants/:id (public show)" do
      get "/plants/#{plant_record.id}"
      expect(response).to have_http_status(:ok)
    end

    it "allows signup" do
  post '/users', params: {
    user: {
      first_name: 'New',
      last_name: 'User',
      email: 'newplant@example.com',
      password: 'pw123456'
    }
  }
  expect([200, 201, 204, 302]).to include(response.status)
end


    it "allows login" do
      post '/session', params: { email: user.email, password: 'password123' }
      expect([200, 204, 302]).to include(response.status)
    end
  end

  context "protected endpoints (unauthenticated)" do
    it "blocks POST /plants" do
      post '/plants', params: { plant: { name: 'Blocked', species: 'Fake', location: 'Desk', watering_frequency: 7 } }
      expect(response).to have_http_status(:forbidden).or have_http_status(:not_found)
    end

    it "blocks PATCH /plants/:id" do
      patch "/plants/#{plant_record.id}", params: { plant: { location: "Desk" } }
      expect(response).to have_http_status(:forbidden).or have_http_status(:not_found)
    end

    it "blocks DELETE /plants/:id" do
      delete "/plants/#{plant_record.id}"
      expect(response).to have_http_status(:forbidden).or have_http_status(:not_found)
    end
  end

  context "protected endpoints (authenticated)" do
    before { sign_in!(email: user.email, password: 'password123') }

    it "allows POST /plants" do
      expect {
        post '/plants', params: { plant: { name: "New Plant", species: "Succulent", location: "Desk", watering_frequency: 5 } }
      }.to change(Plant, :count).by(1)
      expect(response).to have_http_status(:created).or have_http_status(:ok)
    end

    it "allows DELETE /plants/:id" do
      expect {
        delete "/plants/#{plant_record.id}"
      }.to change(Plant, :count).by(-1)
      expect(response).to have_http_status(:no_content).or have_http_status(:ok)
    end
  end
end
