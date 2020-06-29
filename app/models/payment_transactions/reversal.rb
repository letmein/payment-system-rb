# frozen_string_literal: true

module PaymentTransactions
  class Reversal < PaymentTransaction
    include ParentTransactionable

    self.parent_transaction_class = PaymentTransactions::Authorize

    def self.build(parent:)
      new(
        merchant: parent.merchant,
        parent_transaction: parent,
        customer_email: parent.customer_email,
        status: parent.child_status
      )
    end

    def apply!
      parent_transaction.update!(status: PaymentTransaction::STATUS_REVERSED)
      super
    end
  end
end
