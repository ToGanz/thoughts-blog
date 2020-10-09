class ApplicationController < ActionController::Base
  include SessionsHelper

  private
  
  #before filter

  def require_user
    unless current_user
      flash[:alert] = "You must be logged in to perform that action"
      redirect_to login_path
    end
  end
end
