# frozen_string_literal: true

class ApplicationController < ActionController::Base
  helper_method :current_user

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  private

  def authenticate_user
    user_id = session[:user_id]
    @current_user = User.find_by(id: user_id)

    if @current_user.nil?
      session[:return_to] = request.path
      redirect_to new_session_path
    end
  end

end
