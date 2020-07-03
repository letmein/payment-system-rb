# frozen_string_literal: true

class PaymentsController < ApplicationController
  before_action :require_authentication
  before_action :require_merchant

  def index
    @payments = current_user.merchant.payment_transactions
  end

  private

  def require_merchant
    if current_user.role_admin?
      redirect_to admin_payments_path
    elsif !current_user.role_merchant?
      head 403
    end
  end
end
