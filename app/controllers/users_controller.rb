class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:new, :create]  
  skip_before_action :verify_authenticity_token, only: [:create]  

  def new
    @user = User.new
  end

  def create
    user = User.new(user_params)
    if user.save
      render json: { id: user.id, email: user.email }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    # Adjust permitted fields to match your User model
    params.require(:user).permit(:first_name, :last_name, :email, :password)
  end
end
