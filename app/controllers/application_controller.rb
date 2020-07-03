# frozen_string_literal: true

class ApplicationController < ActionController::Base
  helper_method :current_user
  helper_method :signed_in?

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def signed_in?
    current_user.present?
  end

  private

  def require_authentication
    redirect_to '/sign_in' unless signed_in?
  end
end
