# frozen_string_literal: true

module PaymentTransactions
  class Refund < PaymentTransaction
    include ParentTransactionable

    self.parent_transaction_class = PaymentTransactions::Charge

    def self.build(parent:)
      new(
        merchant: parent.merchant,
        parent_transaction: parent,
        customer_email: parent.customer_email,
        status: parent.child_status,
        amount: parent.amount
      )
    end

    def apply!
      parent_transaction.update!(status: PaymentTransaction::STATUS_REFUNDED)
      merchant.update!(total_transaction_sum: merchant.total_transaction_sum - amount)
      super
    end
  end
end
