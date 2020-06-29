# frozen_string_literal: true

require 'mail'

class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    Mail::Address.new(value)
  rescue Mail::Field::ParseError
    record.errors[attribute] << (options[:message] || 'is not a valid email')
  end
end
