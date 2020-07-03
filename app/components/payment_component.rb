# frozen_string_literal: true

class PaymentComponent < ViewComponent::Base
  def initialize(payment:)
    @payment = payment
  end

  def row_id
    "payment-#{payment.id}"
  end

  def type
    case payment
    when PaymentTransactions::Authorize
      'authorize'
    when PaymentTransactions::Reversal
      'reversal'
    when PaymentTransactions::Charge
      'charge'
    when PaymentTransactions::Refund
      'refund'
    end
  end

  private

  attr_reader :payment
end
