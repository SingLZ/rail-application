class DashboardController < ApplicationController
  def index
    # For now, just grab all plants (later you might scope to current_user)
    @plants = Plant.all

    @total_plants = @plants.count

    # "Needs watering" if last_watered_at is too far in the past
    today = Date.today
    @needs_watering = @plants.select do |plant|
      next false if plant.last_watered_at.nil? || plant.watering_frequency.nil?

      days_since = (today - plant.last_watered_at.to_date).to_i
      days_since >= plant.watering_frequency
    end
  end
end
