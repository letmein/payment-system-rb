# frozen_string_literal: true

class ImportAdmin < ApplicationOperation
  step :validate
  step :create_user

  private

  def validate(input)
    contract = AdminUserContract.new(record: User)
    validation_result = contract.call(input)

    if validation_result.success?
      Success(validation_result.to_h[:email])
    else
      Failure(validation_result.errors.to_h.transform_values(&:first))
    end
  end

  def create_user(email)
    password = SecureRandom.hex(4)
    user = User.new(
      role: User::ROLE_ADMIN,
      email: email,
      password: password
    )
    user.save!
    Success(email: email, password: password)
  end
end
