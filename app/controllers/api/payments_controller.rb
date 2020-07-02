# frozen_string_literal: true

module Api
  class PaymentsController < ApplicationController
    http_basic_authenticate_with name: ENV['API_USER'], password: ENV['API_PASSWORD']

    skip_before_action :verify_authenticity_token

    def create
      CreatePayment.new.call(params.to_unsafe_h) do |result|
        result.success do |transaction_id|
          render status: 201, json: { transaction_id: transaction_id }
        end

        result.failure do |message|
          render status: 422, json: { error: message }
        end
      end
    end
  end
end
