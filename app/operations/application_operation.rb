# frozen_string_literal: true

class ApplicationOperation
  include Dry::Transaction

  private

  def db_transaction(input)
    result = nil

    ApplicationRecord.transaction do
      result = yield(Success(input))

      raise ActiveRecord::Rollback if result.failure?
    end

    result
  end
end
