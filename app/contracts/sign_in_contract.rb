# frozen_string_literal: true

class SignInContract < Dry::Validation::Contract
  params do
    required(:email).filled(:string)
    required(:password).filled(:string)
  end

  rule(:email) do |context:|
    context[:user] = User.find_by!(email: value)
  rescue ActiveRecord::RecordNotFound
    key.failure('not found')
  end

  rule(:password) do |context:|
    key.failure('invalid') unless context[:user]&.authenticate(value)
  end
end
