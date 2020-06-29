# frozen_string_literal: true

class CreatePaymentTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :payment_transactions, id: :uuid do |t|
      t.references :merchant, null: false, foreign_key: true
      t.references :parent_transaction, type: :uuid, references: :payment_transactions
      t.string :type, null: false
      t.integer :amount
      t.string :status, null: false
      t.string :customer_email, null: false
      t.string :customer_phone

      t.timestamps
    end
  end
end
