# frozen_string_literal: true

require 'csv'

class ImportCsv
  def initialize(headers:, line_importer:)
    @headers = headers
    @importer = line_importer
  end

  class << self
    def merchant_importer
      ImportCsv.new(
        headers: %i[name description email status],
        line_importer: ImportMerchant.new
      )
    end

    def admin_importer
      ImportCsv.new(
        headers: %i[email],
        line_importer: ImportAdmin.new
      )
    end
  end

  def call(stream)
    users = []
    errors = []

    stream.each_line do |line|
      attrs = parse_line(line)
      result = importer.call(attrs)

      if result.success?
        users << result.value!
      else
        errors << [line, result.failure]
      end
    end

    [users, errors]
  end

  private

  attr_reader :headers, :importer

  def parse_line(line)
    columns = CSV.parse_line(line, col_sep: ';').map(&:to_s).map(&:strip)
    headers.zip(columns).to_h
  end
end
