# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  helper_method :current_user
  before_action :authenticate_user!

  private
  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def authenticate_user!
    return if current_user
    respond_to do |format|
      format.html        { redirect_to new_session_path, alert: "Please sign in first." }
      format.turbo_stream{ redirect_to new_session_path, status: :see_other }
      format.json        { head :forbidden }
    end
  end
end
