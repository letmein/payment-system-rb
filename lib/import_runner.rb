# frozen_string_literal: true

class ImportRunner
  def initialize(importer)
    @importer = importer
  end

  def call(filename)
    input_file = File.open(filename)
    users, errors = importer.call(input_file)

    puts "#{users.size} lines imported"

    report_users(users)
    report_errors(errors)
  ensure
    input_file.close
  end

  private

  attr_reader :importer

  def report_errors(errors)
    return if errors.none?

    puts 'Following lines could not be imported:'
    errors.each do |line, error|
      puts '-----------------'
      puts line
      puts "Errors: #{error}"
    end
  end

  def report_users(users)
    return if users.none?

    puts 'Imported users:'
    users.each do |user|
      puts '-----------------'
      puts "email: #{user[:email]}"
      puts "password: #{user[:password]}"
    end
  end
end
