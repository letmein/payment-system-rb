# frozen_string_literal: true

class User < ApplicationRecord
  belongs_to :merchant, optional: true

  has_secure_password

  ROLES = [
    ROLE_ADMIN = 'admin',
    ROLE_MERCHANT = 'merchant'
  ].freeze

  ROLES.each do |role_name|
    define_method :"role_#{role_name}?" do
      role == role_name
    end
  end
end
