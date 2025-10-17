# app/controllers/plants_controller.rb
class PlantsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :authenticate_user!,      only: [:new, :create, :edit, :update, :destroy]

  before_action :set_public_plant, only: :show
  before_action :set_owned_plant,  only: [:edit, :update, :destroy]

  def index
    @plants = current_user ? current_user.plants : Plant.all
    respond_to do |format|
      format.html
      format.json { render json: @plants, status: :ok }
    end
  end

  def show
    respond_to do |format|
      format.html
      format.json { render json: @plant, status: :ok }
    end
  end

  def new
    @plant = current_user.plants.new
  end

  def create
    @plant = current_user.plants.new(plant_params)
    if @plant.save
      respond_to do |format|
        format.html { redirect_to plants_path, notice: "Plant created successfully!" }
        format.json { render json: @plant, status: :created }   # <-- 201 for specs
      end
    else
      respond_to do |format|
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: { errors: @plant.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  def edit; end

  def update
    if @plant.update(plant_params)
      respond_to do |format|
        format.html { redirect_to @plant, notice: "Plant updated successfully." }
        format.json { render json: @plant, status: :ok }
      end
    else
      respond_to do |format|
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: { errors: @plant.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @plant.destroy
    respond_to do |format|
      format.html { redirect_to plants_path, notice: "Plant deleted successfully." }
      format.json { head :no_content }                           # <-- 204 for specs
    end
  end

  private
  def set_public_plant
    @plant = Plant.find(params[:id])
  end

  def set_owned_plant
    @plant = current_user.plants.find(params[:id])
  end

  def plant_params
    params.require(:plant).permit(:name, :species, :location, :watering_frequency, :last_watered_at)
  end
end
