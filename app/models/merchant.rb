# frozen_string_literal: true

class Merchant < ApplicationRecord
  STATUSES = [
    STATUS_ACTIVE = 'active',
    STATUS_INACTIVE = 'inactive'
  ].freeze

  has_many :payment_transactions

  before_destroy :check_transactions

  validates :status, inclusion: { in: STATUSES }
  validates :email, email: true

  scope :active, -> { where(status: STATUS_ACTIVE) }

  private

  def check_transactions
    throw :abort if payment_transactions.any?
  end
end
