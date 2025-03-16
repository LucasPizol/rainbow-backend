# frozen_string_literal: true

module ApiSpecHelpers
  def json_response
    JSON.parse(response.body, symbolize_names: true)
  end

  def authenticate_user(user)
    token = JwtService.encode(user_id: user.id)

    request.headers.merge!({ Authorization: "Bearer #{token}" })
  end
end

RSpec.configure do |config|
  config.include(ApiSpecHelpers, type: :controller)
end
