# frozen_string_literal: true

module Admin
  class PaymentsController < BaseController
    def index
      @payments = PaymentTransaction.all.includes(:merchant)
    end
  end
end
