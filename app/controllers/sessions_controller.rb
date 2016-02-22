class SessionsController < ApplicationController

  # Action for login view
  def new
  end

  # Action for authentication and creation of a session
  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password])
      if @user.activated?
        log_in @user
        params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
        redirect_back_or(@user)
      else
        message = "Account not activated. Check your emails for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = @user ? 'Invalid email/password combination' : 'Unknown user'
      render 'new'
    end
  end

  # Action for closing a session
  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
