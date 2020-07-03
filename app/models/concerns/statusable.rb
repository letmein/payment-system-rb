# frozen_string_literal: true

module Statusable
  extend ActiveSupport::Concern

  class_methods do
    def define_status_predicates(statuses)
      statuses.each do |status_name|
        define_method :"status_#{status_name}?" do
          status.to_s == status_name
        end
      end
    end
  end
end
