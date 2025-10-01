class SessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:new, :create]
  skip_before_action :verify_authenticity_token, only: :create # if you're calling from API clients

  def new; end

  def create
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      head :no_content
    else
      head :unauthorized
    end
  end

  def destroy
    session.delete(:user_id)
    head :no_content
  end
end
