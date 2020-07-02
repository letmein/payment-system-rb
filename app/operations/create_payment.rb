# frozen_string_literal: true

class CreatePayment < ApplicationOperation
  around :db_transaction

  step :validate
  step :build
  step :persist

  private

  def validate(input)
    validation_result = CreatePaymentContract.new.call(input)

    if validation_result.success?
      Success(input.merge(validation_context: validation_result.context))
    else
      Failure(validation_result.errors(full: true).first.to_s)
    end
  end

  def build(input)
    validation_context = input[:validation_context]
    transaction_params = input[:transaction_params]
    parent = validation_context[:parent_transaction]

    transaction =
      case input[:transaction_type].to_s
      when 'authorize'
        PaymentTransactions::Authorize.build(
          merchant: validation_context[:merchant],
          amount: transaction_params[:amount],
          customer_email: transaction_params[:customer_email]
        )
      when 'reversal'
        PaymentTransactions::Reversal.build(parent: parent)
      when 'charge'
        PaymentTransactions::Charge.build(parent: parent)
      when 'refund'
        PaymentTransactions::Refund.build(parent: parent)
      end

    Success(transaction)
  end

  def persist(transaction)
    if transaction.status_error?
      transaction.save
      Failure('invalid transaction')
    else
      transaction.apply!
      Success(transaction.id)
    end
  end
end
