class UsersController < ApplicationController

  # Controller for a new user (sign up)
  def new
    @user = User.new
  end

  # Crontroller to create a new user
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end

  # Controller for an existing user from database
  def show
    @user = User.find(params[:id])
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

end
