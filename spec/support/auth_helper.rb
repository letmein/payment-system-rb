# frozen_string_literal: true

module AuthHelper
  def sign_in(user)
    page.set_rack_session(user_id: user.id)
  end
end
