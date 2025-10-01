# app/controllers/plants_controller.rb
class PlantsController < ApplicationController
  # Keep reads public; protect mutating routes only
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]

  def index
    plants = Plant.all
    render json: plants, status: :ok
  end

  def show
    plant = Plant.find(params[:id])
    render json: plant, status: :ok
  end

  def create
    plant = current_user.plants.create!(plant_params)
    render json: plant, status: :created
  end

  def update
    plant = current_user.plants.find(params[:id])
    plant.update!(plant_params)
    render json: plant, status: :ok
  end

  def new
    @plant = current_user.plants.new
  end

  def edit
    @plant = current_user.plants.find(params[:id])
  end

  def destroy
    plant = current_user.plants.find(params[:id])
    plant.destroy!
    head :no_content
  end

  private

  def plant_params
    params.require(:plant).permit(:name, :species, :location, :watering_frequency, :last_watered_at)
  end
end
