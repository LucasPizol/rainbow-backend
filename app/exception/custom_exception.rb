# frozen_string_literal: true

class CustomException < StandardError
  def initialize(msg = I18n.t('errors/messages.error'))
    super
  end
end
