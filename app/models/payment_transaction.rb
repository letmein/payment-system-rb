# frozen_string_literal: true

class PaymentTransaction < ApplicationRecord
  self.implicit_order_column = 'created_at'

  STATUSES = [
    STATUS_APPROVED = 'approved',
    STATUS_REVERSED = 'reversed',
    STATUS_REFUNDED = 'refunded',
    STATUS_ERROR = 'error'
  ].freeze

  belongs_to :merchant
  has_many :follow_transactions, foreign_key: 'parent_transaction_id', class_name: 'PaymentTransaction'

  validates :status, inclusion: { in: STATUSES }

  STATUSES.each do |status_name|
    define_method :"status_#{status_name}?" do
      status.to_s == status_name
    end
  end

  def self.expired(expired_at = 1.hour.ago)
    left_outer_joins(:follow_transactions)
      .where('payment_transactions.updated_at < ?', expired_at)
      .where(
        'follow_transactions_payment_transactions.updated_at < ? ' \
          'OR follow_transactions_payment_transactions.id IS NULL',
        expired_at
      )
  end

  def child_status
    if status_approved? || status_refunded?
      STATUS_APPROVED
    else
      STATUS_ERROR
    end
  end

  def apply!
    save!
  end
end
