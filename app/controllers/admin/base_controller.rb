# frozen_string_literal: true

module Admin
  class BaseController < ApplicationController
    before_action :require_authentication
    before_action :require_admin

    private

    def require_admin
      return if current_user.role_admin?

      head 403
    end
  end
end
