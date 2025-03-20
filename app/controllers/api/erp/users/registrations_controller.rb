# frozen_string_literal: true

class Api::Erp::Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json
end
