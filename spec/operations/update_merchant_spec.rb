# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UpdateMerchant do
  subject(:result) { described_class.new.call(merchant: merchant, attrs: attrs) }

  let(:operation) { described_class.new(record: merchant) }
  let(:merchant) { Merchant.find_by!(name: 'TEST') }

  before do
    FactoryBot.create(:merchant, name: 'TEST')
  end

  context 'with valid attrs' do
    let(:attrs) do
      {
        name: 'updated name',
        description: 'some description',
        email: 'updated@example.com',
        status: 'inactive'
      }
    end

    it 'returns success' do
      expect(result).to be_success
    end

    it 'updates the record', :aggregate_failures do
      result
      merchant.reload
      expect(merchant.name).to eq(attrs[:name])
      expect(merchant.description).to eq(attrs[:description])
      expect(merchant.email).to eq(attrs[:email])
      expect(merchant.status).to eq(attrs[:status])
    end
  end

  context 'with invalid attrs' do
    let(:attrs) do
      {
        name: '',
        description: '',
        email: '',
        status: ''
      }
    end

    it 'returns failure' do
      expect(result).to be_failure
    end

    it 'assigns attributes', :aggregate_failures do
      result
      expect(merchant.name).to eq(attrs[:name])
      expect(merchant.description).to eq(attrs[:description])
      expect(merchant.email).to eq(attrs[:email])
      expect(merchant.status).to eq(attrs[:status])
    end

    it 'does not update the record', :aggregate_failures do
      result
      merchant.reload
      expect(merchant.name).to_not eq(attrs[:name])
      expect(merchant.description).to_not eq(attrs[:description])
      expect(merchant.email).to_not eq(attrs[:email])
      expect(merchant.status).to_not eq(attrs[:status])
    end
  end
end
