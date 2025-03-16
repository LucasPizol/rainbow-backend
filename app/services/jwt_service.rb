# frozen_string_literal: true

require 'jwt'

module JwtService
  module_function

  SECRET_KEY = 'secret_key'

  def encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY)
  end

  def decode(token)
    body = JWT.decode(token, SECRET_KEY)[0]
    HashWithIndifferentAccess.new(body)
  rescue StandardError
    nil
  end
end
