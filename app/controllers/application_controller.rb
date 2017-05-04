class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  def require_login
    unless logged_in?
      flash[:error] = 'You must be logged in to access this section'
      redirect_to login_url
    end
  end

  def require_tournament_admin
    redirect_to @tournament, flash: { danger: 'You must be admin to edit' } unless helpers.tournament_admin?
  end
end
