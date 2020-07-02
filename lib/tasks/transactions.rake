# frozen_string_literal: true

namespace :transactions do
  task cleanup: :environment do
    RemoveExpiredTransactionsJob.perform_later
  end
end
