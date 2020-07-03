# frozen_string_literal: true

class SignIn < ApplicationOperation
  step :validate

  private

  def validate(input)
    validation_result = SignInContract.new.call(input)

    if validation_result.success?
      Success(validation_result.context[:user])
    else
      Failure('Invalid email or password')
    end
  end
end
