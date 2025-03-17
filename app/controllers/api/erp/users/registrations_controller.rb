# frozen_string_literal: true

class Api::Erp::Users::RegistrationsController < Devise::RegistrationsController
  skip_before_action :verify_authenticity_token

  respond_to :json
end
