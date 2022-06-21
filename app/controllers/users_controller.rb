class UsersController < ApplicationController

  before_action :require_signin, except: [:new, :create]
  before_action :require_correct_user, only: [:edit, :update]
  before_action :require_admin, only: [:destroy]
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def require_signin
    unless current_user
      redirect_to new_session_url, alert: "Please sign in first!"
    end
  end

  def index 
    @users = User.non_admins
  end

  def show 
    @reviews = @user.reviews
    @favorite_movies = @user.favorite_movies
  end

  def new
    @user = User.new
  end

  def create 
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to user_path(@user), notice: "User successfully created!"
    else 
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "User successfully updated!"
      else 
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to movies_url, notice: "User successfully deleted."
  end

  private 

  def set_user 
    @user = User.find_by!(slug: params[:id])
  end

  def require_correct_user
    @user = User.find(params[:id])
    session[:intended_url] = request.url
    redirect_to root_url unless current_user?(@user)
  end

  def user_params
    params.require(:user).permit( :name, :email, :username, :password, :password_confirmation)
  end
end
