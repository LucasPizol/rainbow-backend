require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module Backend
  class Application < Rails::Application
    config.load_defaults 8.0

    config.autoload_lib(ignore: %w[assets tasks])
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
    config.time_zone = 'America/Sao_Paulo'
    config.i18n.locale = :'pt-BR'
    config.i18n.default_locale = :'pt-BR'
    config.i18n.available_locales = ['pt-BR', :en]
    config.i18n.fallbacks = [:en]
    config.session_store :cookie_store, key: 'auth_session', secure: Rails.env.production?
    config.encoding = "utf-8"
  end
end
