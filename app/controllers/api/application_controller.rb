class Api::ApplicationController < ActionController::API
  before_action :authenticate_user!
  before_action :set_paper_trail_whodunnit
  before_action :set_active_storage_url_options

  def set_paper_trail_whodunnit
    PaperTrail.request.whodunnit = current_user.id if current_user.present?
  end

  def set_pagination
    @page = params[:page].to_i.positive? ? params[:page].to_i : 1
    @per_page = params[:per_page].to_i.positive? ? params[:per_page].to_i : 10
  end

  private

  def set_active_storage_url_options
    ActiveStorage::Current.url_options = { host: 'http://localhost:8080' }
  end
end
