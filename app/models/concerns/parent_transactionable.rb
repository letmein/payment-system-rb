# frozen_string_literal: true

module ParentTransactionable
  extend ActiveSupport::Concern

  included do
    cattr_accessor :parent_transaction_class

    belongs_to :parent_transaction, class_name: 'PaymentTransaction'

    validate :ensure_parent_transaction_type
  end

  def ensure_parent_transaction_type
    return if parent_transaction.is_a?(self.class.parent_transaction_class)

    errors.add(:parent_transaction, "must be a #{self.class.parent_transaction_class}")
  end
end
