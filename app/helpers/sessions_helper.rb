module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id
  end

  def logged_in?
    !session[:user_id].nil?
  end

  def require_login
    unless logged_in?
      flash[:error] = 'You must be logged in to access this section'
      redirect_to login_url
    end
  end

  def current_user
    User.find(session[:user_id])
  end

  def current_user_name
    current_user.name
  end

  def log_out
    session.delete(:user_id)
  end
end
