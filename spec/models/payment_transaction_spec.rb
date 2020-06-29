# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PaymentTransaction do
  describe '.expired' do
    subject(:result) { described_class.expired }

    it 'returns a single transaction updated more than 1h ago' do
      record = FactoryBot.create(:authorize_transaction, :expired)

      expect(result).to match_array([record])
    end

    it 'returns related transactions updated more than 1h ago' do
      auth = FactoryBot.create(:authorize_transaction, :expired)
      charge = FactoryBot.create(:charge_transaction, :expired, parent_transaction: auth)

      expect(result).to match_array([auth, charge])
    end

    it 'does not return single transactions updated recently' do
      FactoryBot.create(:authorize_transaction)

      expect(result).to be_blank
    end

    it 'does not return old transactions with a follow transaction updated recently' do
      auth = FactoryBot.create(:authorize_transaction, :expired)
      FactoryBot.create(:charge_transaction, parent_transaction: auth)

      expect(result).to be_blank
    end
  end
end
