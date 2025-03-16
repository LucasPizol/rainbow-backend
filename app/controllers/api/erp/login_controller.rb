# frozen_string_literal: true

class Api::Erp::LoginController < ApplicationController
  skip_before_action :authenticate_request

  def create
    @user = User.find_by(email: login_params[:email])

    unless @user&.authenticate(login_params[:password])
      return render json: { message: 'Usuário ou senha inválidos' },
                    status: :unauthorized
    end

    @token = JwtService.encode(user_id: @user.id)
  rescue StandardError => e
    render json: { message: 'Usuário ou senha inválidos' }, status: :unauthorized
  end

  private

  def login_params
    params.require(:user).permit(:email, :password)
  end
end
