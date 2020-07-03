# frozen_string_literal: true

class UpdateMerchant < ApplicationOperation
  step :assign_attrs
  step :validate
  step :persist

  private

  def assign_attrs(input)
    attrs = input[:attrs].slice(:name, :description, :email, :status)
    input[:merchant].assign_attributes(attrs)
    Success(input)
  end

  def validate(input)
    contract = MerchantUpdateContract.new(record: input[:merchant])
    validation_result = contract.call(input[:attrs])

    if validation_result.success?
      Success(input)
    else
      Failure(validation_result.errors.to_h.transform_values(&:first))
    end
  end

  def persist(input)
    input[:merchant].save!
    Success(true)
  end
end
