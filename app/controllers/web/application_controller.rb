# frozen_string_literal: true

class Web::ApplicationController < ActionController::Base
  before_action :set_active_storage_url_options
  allow_browser versions: :modern
  layout 'web'

  private

  def set_active_storage_url_options
    ActiveStorage::Current.url_options = { host: 'http://localhost:8080' }
  end
end
