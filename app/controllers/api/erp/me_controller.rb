# frozen_string_literal: true

class Api::Erp::MeController < ActionController::API
  def index
    @user = current_user
  end
end
