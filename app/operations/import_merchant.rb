# frozen_string_literal: true

class ImportMerchant < ApplicationOperation
  step :create_merchant
  step :create_user

  private

  def create_merchant(input)
    UpdateMerchant.new.call(merchant: Merchant.new, attrs: input)
  end

  def create_user(merchant)
    password = SecureRandom.hex(4)
    user = User.new(
      role: User::ROLE_MERCHANT,
      merchant: merchant,
      email: merchant.email,
      password: password
    )
    user.save!
    Success(email: merchant.email, password: password)
  end
end
