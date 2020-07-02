# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Payments API' do
  let(:authorization) do
    ActionController::HttpAuthentication::Basic.encode_credentials(
      ENV['API_USER'],
      ENV['API_PASSWORD']
    )
  end

  scenario 'successful request', :aggregate_failures do
    merchant = FactoryBot.create(:merchant)

    headers = {
      'HTTP_AUTHORIZATION' => authorization,
      'CONTENT_TYPE' => 'application/json'
    }

    params = {
      merchant_email: merchant.email,
      transaction_type: 'authorize',
      transaction_params: {
        customer_email: 'customer@example.com',
        amount: 10
      }
    }

    post '/api/payments', headers: headers, params: params.to_json

    expect(response).to have_http_status(201)
    expect(response.content_type).to eq('application/json; charset=utf-8')
    expect(JSON.parse(response.body)).to eq('transaction_id' => PaymentTransaction.last.id)
  end

  scenario 'unprocessable request', :aggregate_failures do
    headers = {
      'HTTP_AUTHORIZATION' => authorization,
      'CONTENT_TYPE' => 'application/json'
    }

    post '/api/payments', headers: headers, params: {}.to_json

    expect(response).to have_http_status(422)
    expect(response.content_type).to eq('application/json; charset=utf-8')
    expect(JSON.parse(response.body)).to eq('error' => 'merchant_email is missing')
  end

  scenario 'failed authentication' do
    headers = {
      'CONTENT_TYPE' => 'application/json'
    }

    post '/api/payments', headers: headers, params: {}.to_json

    expect(response).to have_http_status(401)
  end
end
