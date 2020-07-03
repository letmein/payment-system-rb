# frozen_string_literal: true

class MerchantUpdateContract < Dry::Validation::Contract
  option :record

  params do
    required(:name).filled(:string, max_size?: 50)
    required(:description).value(:string, max_size?: 255)
    required(:email).filled(:string, format?: URI::MailTo::EMAIL_REGEXP)
    required(:status).filled(:string, included_in?: Merchant::STATUSES)
  end

  rule(:name) do
    key.failure('name is already used by another merchant') if record.exists?(name: value)
  end

  rule(:email) do
    key.failure('email is already used by another merchant') if record.exists?(email: value)
  end
end
