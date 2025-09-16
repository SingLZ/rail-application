require "rails_helper"

RSpec.describe User, type: :model do
  describe "#full_name" do
    it "returns the full name for a user" do
      user = User.new(first_name: "Sing", last_name: "Zheng")

      expect(user.full_name).to eq("Sing Zheng")
    end

    it "handles missing last_name" do
      user = User.new(first_name: "Sing")

      expect(user.full_name).to eq("Sing ")
    end

    it "handles missing first_name" do
      user = User.new(last_name: "Zheng")

      expect(user.full_name).to eq(" Zheng")
    end

    it "returns empty string if both names are missing" do
      user = User.new

      expect(user.full_name).to eq(" ")
    end
  end
end
