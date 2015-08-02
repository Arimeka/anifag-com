require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module AnifagCom
  class Application < Rails::Application
    config.time_zone = 'Europe/Moscow'
    config.encoding  = 'utf-8'
    config.filter_parameters += [:password]

    config.assets.initialize_on_precompile = false
    config.tinymce.install = :compile

    config.i18n.available_locales = [:ru]
    config.i18n.enforce_available_locales = false
    config.i18n.default_locale = :ru

    config.active_record.raise_in_transactional_callbacks = true

    config.generators do |g|
      g.template_engine     :haml
      g.test_framework      :rspec, fixture: false, view: false
      g.integration_tool    :rspec
      g.performance_tool    :rspec
      g.fixture_replacement :factory_girl, dir: 'spec/factories'
      g.view_specs          false
      g.helper_specs        false
    end
  end
end
