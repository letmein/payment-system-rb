# frozen_string_literal: true

class CreatePaymentContract < Dry::Validation::Contract
  Authorize = Dry::Schema.Params do
    required(:amount).value(:integer, gt?: 0)
    required(:customer_email).value(:string, format?: URI::MailTo::EMAIL_REGEXP)
    optional(:customer_phone).filled(:string)
  end

  Follow = Dry::Schema.Params do
    required(:reference_id).filled(:string)
  end

  params do
    required(:merchant_email).filled(:string)
    required(:transaction_type).value(:string, included_in?: %w[authorize charge refund reversal])
    required(:transaction_params).hash
  end

  rule(:merchant_email) do |context:|
    context[:merchant] = Merchant.active.lock.find_by!(email: value)
  rescue ActiveRecord::RecordNotFound
    key.failure('not found')
  end

  rule(:transaction_type, :transaction_params) do
    schema = values[:transaction_type] == 'authorize' ? Authorize : Follow
    result = schema.call(values[:transaction_params])
    if result.failure?
      msg = result.errors(full: true).first.to_s
      key(:transaction_params).failure(msg)
    end
  end

  rule(:transaction_params) do |context:|
    if value[:reference_id]
      context[:parent_transaction] =
        context[:merchant].payment_transactions.lock.find(value[:reference_id])
    end
  rescue ActiveRecord::RecordNotFound
    key.failure('not found')
  end
end
