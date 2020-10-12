class SessionsController < ApplicationController
  before_action :authenticate_user, only: [:destroy]

  def create
    user = User.find_by(name: session_params[:name])
    if user && user.authenticate(session_params[:password])
      session[:user_id] = user.id
      back_url = session[:return_url] || root_path
      session.delete(:return_url)
      redirect_to back_url
    else
      flash.alert = "The user name or password is incorrect."
      redirect_to new_session_path
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end

  private

  def session_params
    params.require(:session).permit(:name, :password)
  end
end
