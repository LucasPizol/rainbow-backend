# frozen_string_literal: true

class ApplicationController < ActionController::API
  before_action :authenticate_user!
  before_action :set_paper_trail_whodunnit

  def set_paper_trail_whodunnit
    PaperTrail.request.whodunnit = current_user.id if current_user.present?
  end

  def set_pagination
    @page = params[:page].to_i.positive? ? params[:page].to_i : 1
    @per_page = params[:per_page].to_i.positive? ? params[:per_page].to_i : 10
  end
end
