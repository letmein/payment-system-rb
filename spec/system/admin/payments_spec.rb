# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin payments page' do
  scenario 'admin user views payments of all merchants' do
    user = FactoryBot.create(:user, :admin)

    FactoryBot.create(:authorize_transaction, customer_email: 'customer1@example.com')
    FactoryBot.create(:authorize_transaction, customer_email: 'customer2@example.com')

    sign_in user

    visit '/admin/payments'

    assert_text 'customer1@example.com'
    assert_text 'customer2@example.com'
  end
end
