# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def exists?(**conditions)
    self.class.where.not(id: id).exists?(**conditions)
  end
end
