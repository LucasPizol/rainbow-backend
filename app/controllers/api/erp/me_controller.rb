# frozen_string_literal: true

class Api::Erp::MeController < Api::ApplicationController
  def index
    @user = current_user
  rescue StandardError => e
    render json: { error: e.message }, status: :bad_request
  end
end
