class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:new, :create]  
  skip_before_action :verify_authenticity_token, only: [:create]  

  def new
    @user = User.new
  end

  def create
  @user = User.new(user_params)
  if User.exists?(email: @user.email)
    redirect_to new_session_path, alert: "Email already registered. Please log in."
  elsif @user.save
    redirect_to new_session_path, notice: "Account created. Please log in."
  else
    render :new, status: :unprocessable_content
  end
end


  private

  def user_params
    # Adjust permitted fields to match your User model
    params.require(:user).permit(:first_name, :last_name, :email, :password)
  end
end
