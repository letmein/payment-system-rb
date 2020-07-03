# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { 'Password1' }

    trait :admin do
      role { User::ROLE_ADMIN }
    end

    trait :merchant do
      role { User::ROLE_MERCHANT }
      merchant
    end
  end
end
