# frozen_string_literal: true

module PaymentTransactions
  class Authorize < PaymentTransaction
    validates :amount, numericality: { greater_than: 0 }

    def self.build(merchant:, amount:, customer_email:)
      new(
        merchant: merchant,
        amount: amount,
        customer_email: customer_email,
        status: PaymentTransaction::STATUS_APPROVED
      )
    end
  end
end
