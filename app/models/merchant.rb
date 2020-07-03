# frozen_string_literal: true

class Merchant < ApplicationRecord
  include Statusable

  STATUSES = [
    STATUS_ACTIVE = 'active',
    STATUS_INACTIVE = 'inactive'
  ].freeze

  has_many :payment_transactions
  has_many :users, dependent: :destroy

  before_destroy :check_transactions

  scope :active, -> { where(status: STATUS_ACTIVE) }

  define_status_predicates STATUSES

  private

  def check_transactions
    throw :abort if payment_transactions.any?
  end
end
