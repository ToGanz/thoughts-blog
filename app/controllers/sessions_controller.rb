class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by_email(params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password])
      reset_session
      log_in(@user)
      flash[:notice] = "Logged in succesfully"
      redirect_to @user
    else
      flash.now[:alert] = "There was something wrong with your login details"
      render 'new'
    end 
  end

  def destroy
    log_out
    redirect_to root_url
  end

end
