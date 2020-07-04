# frozen_string_literal: true

class UpdateMerchant < ApplicationOperation
  step :validate
  step :persist

  private

  def validate(input)
    merchant = input[:merchant]

    contract = MerchantUpdateContract.new(record: merchant)
    validation_result = contract.call(input[:attrs])

    merchant.assign_attributes(validation_result.to_h)

    if validation_result.success?
      Success(merchant)
    else
      Failure(validation_result.errors.to_h.transform_values(&:first))
    end
  end

  def persist(merchant)
    merchant.save!
    Success(merchant)
  end
end
