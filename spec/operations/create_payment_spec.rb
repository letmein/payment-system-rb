# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CreatePayment do
  subject(:transaction) { described_class.new }

  it 'rejects blank payload', :aggregate_failures do
    result = transaction.call

    expect(result).to be_failure
    expect(result.failure).to eq('merchant_email is missing')
  end

  it 'rejects non-existent merchant emails', :aggregate_failures do
    result = transaction.call(
      merchant_email: 'foo@example.com',
      transaction_type: 'authorize',
      transaction_params: { amount: 1 }
    )

    expect(result).to be_failure
    expect(result.failure).to eq('merchant_email not found')
  end

  it 'rejects inactive merchant', :aggregate_failures do
    FactoryBot.create(:merchant, :inactive, email: 'foo@example.com')

    result = transaction.call(
      merchant_email: 'foo@example.com',
      transaction_type: 'authorize',
      transaction_params: { amount: 1 }
    )

    expect(result).to be_failure
    expect(result.failure).to eq('merchant_email not found')
  end

  it 'creates authorize transaction' do
    FactoryBot.create(:merchant, email: 'foo@example.com')

    result = transaction.call(
      merchant_email: 'foo@example.com',
      transaction_type: 'authorize',
      transaction_params: { amount: 1, customer_email: 'customer@example.com' }
    )

    expect(result).to be_success
    expect(result.value!).to eq(PaymentTransactions::Authorize.last.id)
  end

  it 'creates reversal transaction', :aggregate_failures do
    merchant = FactoryBot.create(:merchant)
    auth_transaction = FactoryBot.create(:authorize_transaction, merchant: merchant)

    result = transaction.call(
      merchant_email: merchant.email,
      transaction_type: 'reversal',
      transaction_params: { reference_id: auth_transaction.id }
    )

    expect(result).to be_success
    expect(result.value!).to eq(PaymentTransactions::Reversal.last.id)
    expect(auth_transaction.reload).to be_status_reversed
  end

  it 'creates charge transaction', :aggregate_failures do
    merchant = FactoryBot.create(:merchant, total_transaction_sum: 15)
    auth_transaction = FactoryBot.create(:authorize_transaction, merchant: merchant, amount: 3)

    result = transaction.call(
      merchant_email: merchant.email,
      transaction_type: 'charge',
      transaction_params: { reference_id: auth_transaction.id }
    )

    expect(result).to be_success
    expect(result.value!).to eq(PaymentTransactions::Charge.last.id)
    expect(merchant.reload.total_transaction_sum).to eq(18)
  end

  it 'creates refund transaction', :aggregate_failures do
    merchant = FactoryBot.create(:merchant, total_transaction_sum: 18)
    auth_transaction = FactoryBot.create(:authorize_transaction, merchant: merchant)
    charge_transaction =
      FactoryBot.create(
        :charge_transaction,
        merchant: merchant,
        parent_transaction: auth_transaction,
        amount: 3
      )

    result = transaction.call(
      merchant_email: merchant.email,
      transaction_type: 'refund',
      transaction_params: { reference_id: charge_transaction.id }
    )

    expect(result).to be_success
    expect(result.value!).to eq(PaymentTransactions::Refund.last.id)
    expect(charge_transaction.reload).to be_status_refunded
    expect(merchant.reload.total_transaction_sum).to eq(15)
  end
end
