class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :fetch_user

  # def current_user
  #   @user ||= User.find_by(id: session[:user_id]) if session[:used_id]
  # end

  private
  def fetch_user
    @current_user = User.find_by :id => session[ :user_id ] if session[ :user_id ]
    session[ :user_id ] = nil unless @current_user.present?
  end

  def check_if_logged_in
    redirect_to login_path unless @current_user.present?
  end
end
