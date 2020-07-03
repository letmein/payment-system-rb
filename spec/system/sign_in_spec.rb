# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sign in page' do
  scenario 'existing admin user logs in' do
    FactoryBot.create(:user, :admin, email: 'test@example.com', password: '12345')

    visit '/sign_in'
    fill_in 'Email', with: 'test@example.com'
    fill_in 'Password', with: '12345'
    click_on 'Sign in'

    assert_current_path('/admin/merchants')
  end

  scenario 'existing merchant user logs in' do
    FactoryBot.create(:user, :merchant, email: 'test@example.com', password: '12345')

    visit '/sign_in'
    fill_in 'Email', with: 'test@example.com'
    fill_in 'Password', with: '12345'
    click_on 'Sign in'

    assert_current_path('/payments')
  end

  scenario 'submitting invalid credentials' do
    visit '/sign_in'
    fill_in 'Email', with: 'test@example.com'
    fill_in 'Password', with: '12345'
    click_on 'Sign in'

    assert_current_path('/sign_in')

    assert_text('Invalid email or password')
  end
end
