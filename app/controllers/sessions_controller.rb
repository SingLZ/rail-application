# app/controllers/sessions_controller.rb
class SessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:new, :create]
  # If you protect from forgery, skip CSRF for API-style requests:
  skip_before_action :verify_authenticity_token, only: [:create, :destroy]

  def new
    redirect_to dashboard_path if current_user
  end

  def create
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      respond_to do |format|
        format.html         { redirect_to dashboard_path, status: :see_other, notice: "Signed in!" }
        format.turbo_stream { redirect_to dashboard_path, status: :see_other }
        format.json         { head :no_content }    # <- what your spec expects (204)
      end
    else
      respond_to do |format|
        format.html do
          flash.now[:alert] = "Invalid email or password"
          render :new, status: :unprocessable_content
        end
        format.turbo_stream { render :new, status: :unprocessable_content }
        format.json         { render json: { error: "invalid_credentials" }, status: :unauthorized }
      end
    end
  end

  def destroy
    reset_session
    respond_to do |format|
      format.html         { redirect_to new_session_path, notice: "Logged out." }
      format.turbo_stream { redirect_to new_session_path, status: :see_other }
      format.json         { head :no_content }
    end
  end
end
