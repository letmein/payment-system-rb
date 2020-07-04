# frozen_string_literal: true

require_relative '../import_runner'

def run_import(importer, filename = ENV['FILE'])
  abort 'FILE is required' unless filename

  ImportRunner.new(importer).call(filename)
end

namespace :import do
  task merchants: :environment do
    run_import(ImportCsv.merchant_importer)
  end

  task admins: :environment do
    run_import(ImportCsv.admin_importer)
  end
end
