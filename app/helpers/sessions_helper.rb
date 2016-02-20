module SessionsHelper

  # Logs in the given user.
  def log_in(user)
    session[:user_id] = user.id
  end

  # Returns the current logged-in user (if any).
  # Otherwise the current user is defined from the cookie then logged in.
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if (user && user.authenticated?(cookies[:remember_token]))
        log_in user
        @current_user = user
      end
    end
  end

  # Remembers a user in a persistent session.
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # Forgets the persistent session of a user
  def forget(user)
    user.forget
    cookies.delete :user_id
    cookies.delete :remember_token
  end

  # Returns true if the user is logged in, false otherwise.
  def logged_in?
    !current_user.nil?
  end

  # Returns true if the user is logged in, false otherwise.
  def current_user?(user)
    user == current_user
  end

  # Logs out the current user.
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  # Store requested url
  def store_location
    session[:forwarding_url] = request.url if request.get?
  end

  # Redirect to stored url or default
  def forward_back_or(default)
    redirect_to (session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end
end