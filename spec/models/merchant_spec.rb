# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Merchant do
  describe '#destroy' do
    let(:merchant) { Merchant.find_by(email: email) }
    let(:email) { 'test@example.com' }

    before do
      FactoryBot.create(:merchant, email: email)
    end

    context 'with associated payment transactions' do
      before do
        FactoryBot.create(:authorize_transaction, merchant: merchant)
      end

      it 'does not remove the merchant' do
        expect { merchant.destroy }.to_not change(Merchant, :count)
      end
    end

    context 'with unrelated payment transactions' do
      before do
        FactoryBot.create(:authorize_transaction)
      end

      it 'removes the merchant' do
        expect { merchant.destroy }.to change(Merchant, :count).by(-1)
      end
    end

    context 'without payment transactions' do
      it 'removes the merchant' do
        expect { merchant.destroy }.to change(Merchant, :count).by(-1)
      end
    end
  end
end
