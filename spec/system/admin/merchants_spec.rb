# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin merchants page' do
  scenario 'admin user views all merchants' do
    user = FactoryBot.create(:user, :admin)

    FactoryBot.create(:merchant, name: 'Merchant 1')
    FactoryBot.create(:merchant, name: 'Merchant 2')

    sign_in user

    visit '/admin/merchants'

    assert_text 'Merchant 1'
    assert_text 'Merchant 2'
  end

  scenario 'admin user deletes a merchant' do
    user = FactoryBot.create(:user, :admin)

    merchant = FactoryBot.create(:merchant, name: 'Merchant 1')
    FactoryBot.create(:merchant, name: 'Merchant 2')

    sign_in user

    visit '/admin/merchants'

    within "#merchant-#{merchant.id}" do
      click_on 'Delete'
    end

    assert_current_path '/admin/merchants'
    assert_text 'Merchant has been deleted'
    assert_no_text 'Merchant 1'
    assert_text 'Merchant 2'
  end

  scenario 'admin user edits a merchant' do
    user = FactoryBot.create(:user, :admin)

    merchant = FactoryBot.create(:merchant, name: 'Merchant 1')
    FactoryBot.create(:merchant, name: 'Merchant 2')

    sign_in user

    visit '/admin/merchants'

    within "#merchant-#{merchant.id}" do
      click_on 'Edit'
    end

    assert_current_path "/admin/merchants/#{merchant.id}/edit"
    fill_in 'Name', with: 'Merchant-123'
    click_on 'Save'

    assert_current_path '/admin/merchants'
    assert_text 'Merchant has been updated'
    assert_no_text 'Merchant 1'
    assert_text 'Merchant-123'
    assert_text 'Merchant 2'
  end

  scenario 'admin user submits invalid merchant info' do
    user = FactoryBot.create(:user, :admin)
    merchant = FactoryBot.create(:merchant)

    sign_in user

    visit "/admin/merchants/#{merchant.id}/edit"

    fill_in 'Name', with: ''
    click_on 'Save'

    assert_current_path "/admin/merchants/#{merchant.id}"
    assert_selector '#merchant_name.is-invalid'
    assert_text 'must be filled'

    fill_in 'Name', with: 'TEST'
    click_on 'Save'

    assert_current_path '/admin/merchants'
    assert_text 'TEST'
  end
end
