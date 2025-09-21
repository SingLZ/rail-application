class PlantsController < ApplicationController
  before_action :set_plant, only: [ :show, :edit, :update ]

  # GET /plants
  def index
    @plants = Plant.all
  end

  # GET /plants/:id
  def show
  end

  # GET /plants/new
  def new
    @plant = Plant.new
  end

  # GET /plants/:id/edit
  def edit
  end

  def create
    # Split the entered full name into first and last
    full_name = params[:plant][:user_name].to_s.strip
    first_name = full_name.split.first
    last_name = full_name.split.drop(1).join(" ")

    # Find existing user by email or create a new one
    user = User.find_or_create_by(email: params[:plant][:user_email]) do |u|
      u.first_name = first_name
      u.last_name  = last_name
    end

    # Assign the plant to that user
    @plant = user.plants.new(plant_params)

    if @plant.save
      redirect_to plants_path, notice: "Plant was successfully created."
    else
      Rails.logger.debug @plant.errors.full_messages
      render :new, status: :unprocessable_content
    end
  end




  def update
    if @plant.update(plant_params)
      redirect_to @plant, notice: "Plant was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_plant
    @plant = Plant.find(params[:id])
  end

  def plant_params
    params.require(:plant).permit(:name, :species, :location, :watering_frequency, :last_watered_at)
  end
end
