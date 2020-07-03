# frozen_string_literal: true

class SessionsController < ApplicationController
  def create
    SignIn.new.call(params.to_unsafe_h) do |result|
      result.success do |user|
        session[:user_id] = user.id
        redirect_to after_sign_in_path(user)
      end

      result.failure do |message|
        @error = message
        render :new
      end
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to '/sign_in'
  end

  private

  def after_sign_in_path(user)
    if user.role_admin?
      admin_merchants_path
    else
      payments_path
    end
  end
end
