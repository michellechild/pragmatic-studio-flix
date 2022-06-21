class SessionsController < ApplicationController

  def new
  end

  def create
    user_email = User.find_by(email: params[:email_or_username])
    username = User.find_by(username: params[:email_or_username])

    user = username || user_email

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to session[:intended_url] || user_path(user.id), 
                  notice: "Welcome Back #{user.name}!"
      session[:intended_url] = nil
    else
      flash.now[:alert] = "User not found"
      render :new
    end
  end
  
  def destroy
    session[:user_id] = nil
    redirect_to movies_url, notice: "You're now signed out!"
  end

end
