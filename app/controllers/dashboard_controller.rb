class DashboardController < ApplicationController
  before_action :authenticate_user!
  def index

   @plants = current_user.plants

    @total_plants = @plants.count

    today = Date.today
    @needs_watering = @plants.select do |plant|
      next false if plant.last_watered_at.nil? || plant.watering_frequency.nil?

      days_since = (today - plant.last_watered_at.to_date).to_i
      days_since >= plant.watering_frequency
    end
  end
end
