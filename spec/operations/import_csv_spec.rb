# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ImportCsv do
  describe '.merchant_importer' do
    it 'imports merchant data', :aggregate_failures do
      input = StringIO.new <<~CSV
        Merchant 1;some description; merchant-1@example.com; active
        Merchant 2;; merchant-2@example.com; inactive
        ;;kdfdgfgfd
      CSV

      users, errors = ImportCsv.merchant_importer.call(input)

      expect(users.size).to eq(2)

      expect(users[0][:email]).to eq('merchant-1@example.com')
      expect(users[0][:password]).to be_kind_of(String)

      expect(users[1][:email]).to eq('merchant-2@example.com')
      expect(users[1][:password]).to be_kind_of(String)

      expect(User.where(role: User::ROLE_MERCHANT).count).to eq(2)

      expect(errors.size).to eq(1)
    end
  end

  describe '.admin_importer' do
    it 'imports admin data', :aggregate_failures do
      input = StringIO.new <<~CSV
        admin-1@example.com
        sfdfs
        admin-2@example.com
      CSV

      users, errors = ImportCsv.admin_importer.call(input)

      expect(users.size).to eq(2)

      expect(users[0][:email]).to eq('admin-1@example.com')
      expect(users[0][:password]).to be_kind_of(String)

      expect(users[1][:email]).to eq('admin-2@example.com')
      expect(users[1][:password]).to be_kind_of(String)

      expect(User.count).to eq(2)

      expect(errors.size).to eq(1)
    end
  end
end
