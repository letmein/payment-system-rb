class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :email, null: false, index: true
      t.string :password
      t.string :password_digest
      t.string :role, null: false
      t.references :merchant, foreign_key: true

      t.timestamps
    end
  end
end
