# frozen_string_literal: true

class Api::Erp::Users::SessionsController < Devise::SessionsController
  skip_before_action :verify_authenticity_token
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    if resource.persisted?
      render json: {
        id: resource.id,
        email: resource.email,
        name: resource.name,
        createdAt: resource.created_at,
        updatedAt: resource.updated_at
      }
    else
      render json: { message: 'Usuário ou senha inválidos' }, status: :unauthorized
    end
  end

  def flash
    {}
  end

  def respond_to
  end
end
