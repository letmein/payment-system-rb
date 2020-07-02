# frozen_string_literal: true

class RemoveExpiredTransactionsJob < ApplicationJob
  queue_as :default

  def perform(*)
    PaymentTransaction.expired.delete_all
  end
end
