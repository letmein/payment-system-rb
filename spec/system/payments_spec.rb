# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Merchant payments page' do
  scenario 'merchant views their payments' do
    user = FactoryBot.create(:user, :merchant)
    FactoryBot.create(:authorize_transaction, merchant: user.merchant, customer_email: 'customer@example.com')

    sign_in user

    visit '/payments'

    assert_text 'customer@example.com'
  end

  scenario 'admin user is redirected to the admin page' do
    user = FactoryBot.create(:user, :admin)

    sign_in user

    visit '/payments'

    assert_current_path '/admin/payments'
  end
end
