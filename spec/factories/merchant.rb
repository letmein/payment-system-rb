# frozen_string_literal: true

FactoryBot.define do
  factory :merchant do
    sequence(:name) { |n| "Merchant#{n}" }
    sequence(:email) { |n| "merchant#{n}@example.com" }
    active

    trait :active do
      status { Merchant::STATUS_ACTIVE }
    end

    trait :inactive do
      status { Merchant::STATUS_INACTIVE }
    end
  end
end
