# frozen_string_literal: true

FactoryBot.define do
  factory :payment_transaction do
    merchant
    sequence(:customer_email) { |n| "customer#{n}@example.com" }
    approved

    trait :approved do
      status { PaymentTransaction::STATUS_APPROVED }
    end

    trait :reversed do
      status { PaymentTransaction::STATUS_REVERSED }
    end

    trait :refunded do
      status { PaymentTransaction::STATUS_REFUNDED }
    end

    trait :error do
      status { PaymentTransaction::STATUS_ERROR }
    end

    trait :expired do
      updated_at { 2.hours.ago }
    end

    factory :authorize_transaction, class: 'PaymentTransactions::Authorize' do
      amount { 1 }
    end

    factory :charge_transaction, class: 'PaymentTransactions::Charge' do
      amount { 1 }
    end

    factory :refund_transaction, class: 'PaymentTransactions::Refund' do
      amount { 1 }
    end

    factory :reversal_transaction, class: 'PaymentTransactions::Reversal'
  end
end
