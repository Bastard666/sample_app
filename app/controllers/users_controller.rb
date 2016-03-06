class UsersController < ApplicationController
  before_action :logged_in_user,  only: [:index, :edit, :update, :destroy]
  before_action :correct_user,    only: [:edit, :update]
  before_action :admin,           only: [:destroy]

  # Controller for a new user (sign up)
  def new
    @user = User.new
  end

  # Crontroller to create a new user
  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_mail
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new'
    end
  end

  # Controller to delete a user
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  # Controller for all users display
  def index
    @users = User.where(activated: true).paginate(page: params[:page])
  end

  # Controller for an existing user from database
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
    redirect_to root_url and return unless @user.activated?
  end

  # Controller for editing an existing user from database
  def edit
    @user = User.find(params[:id])
  end

  #  Controller for updating user informations
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  #  Befors filters

  # Confirms the right user.
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user? @user
  end

  def admin
    redirect_to(root_url) unless current_user.admin?
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

end
