# frozen_string_literal: true

module PaymentTransactions
  class Charge < PaymentTransaction
    include ParentTransactionable

    self.parent_transaction_class = PaymentTransactions::Authorize

    def self.build(parent:)
      new(
        merchant: parent.merchant,
        parent_transaction: parent,
        status: parent.child_status,
        customer_email: parent.customer_email,
        amount: parent.amount
      )
    end

    def apply!
      merchant.update!(total_transaction_sum: merchant.total_transaction_sum + amount)
      super
    end
  end
end
