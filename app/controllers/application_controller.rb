class ApplicationController < ActionController::Base
  include SessionsHelper

  private
  
  #before filter

  def require_user
    unless current_user
      flash[:alert] = "Please log in."
      redirect_to login_path
    end
  end

  # Confirms an admin user.
  def require_admin 
    redirect_to(root_url) unless current_user.admin?
  end
end
