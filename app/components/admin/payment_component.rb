# frozen_string_literal: true

module Admin
  class PaymentComponent < ::PaymentComponent
    delegate :merchant, to: :payment
  end
end
