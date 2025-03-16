# frozen_string_literal: true

class ApplicationController < ActionController::API
  before_action :authenticate_request
  before_action :set_paper_trail_whodunnit

  def authenticate_request
    header = request.headers['Authorization']
    header = header.split.last if header

    begin
      @decoded = JwtService.decode(header)

      if @decoded.blank?
        return render json: { message: 'Você precisa estar autenticado para acessar este recurso' },
                      status: :unauthorized
      end

      @current_user = User.find(@decoded[:user_id])
    rescue JWT::DecodeError => e
      render json: { message: 'Você precisa estar autenticado para acessar este recurso' }, status: :unauthorized
    end
  end

  def set_paper_trail_whodunnit
    PaperTrail.request.whodunnit = @current_user.id if @current_user.present?
  end

  def set_pagination
    @page = params[:page].to_i.positive? ? params[:page].to_i : 1
    @per_page = params[:per_page].to_i.positive? ? params[:per_page].to_i : 10
  end
end
