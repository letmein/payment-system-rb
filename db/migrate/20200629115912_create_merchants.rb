# frozen_string_literal: true

class CreateMerchants < ActiveRecord::Migration[6.0]
  def change
    create_table :merchants do |t|
      t.string :name, null: false, index: { unique: true }
      t.string :description
      t.string :email, null: false, index: { unique: true }
      t.string :status, null: false
      t.integer :total_transaction_sum, default: 0, null: false

      t.timestamps
    end

    add_index :merchants, %i[email status]
  end
end
