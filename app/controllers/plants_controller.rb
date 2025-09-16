class PlantsController < ApplicationController
  # GET /plants
  def index
    @plants = Plant.all
  end

  # GET /plants/:id
  def show
    @plant = Plant.find(params[:id])
  end

  # GET /plants/new
  def new
    @plant = Plant.new
  end

  # GET /plants/:id/edit
  def edit
    @plant = Plant.find(params[:id])
  end
end
