# frozen_string_literal: true

class AdminUserContract < Dry::Validation::Contract
  option :record

  params do
    required(:email).filled(:string, format?: URI::MailTo::EMAIL_REGEXP)
  end

  rule(:email) do
    key.failure('email is already used by another merchant') if record.exists?(email: value)
  end
end
