# frozen_string_literal: true

ENV['RAILS_ENV'] = 'test'

require File.expand_path('../config/environment', __dir__)
require 'database_cleaner'
require 'rspec/rails'
require 'shoulda/matchers'
Dir[Rails.root.join('spec/helpers/**/*.rb')].sort.each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.expect_with(:rspec) do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
    DatabaseCleaner.strategy = :transaction
  end

  config.around(:each) do |spec|
    DatabaseCleaner.cleaning { spec.run }
  end

  config.mock_with(:rspec) do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.use_transactional_fixtures = false
  config.infer_spec_type_from_file_location!

  config.filter_run_excluding(broken: true)

  config.include(FactoryBot::Syntax::Methods)
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework(:rspec)
    with.library(:rails)
  end
end
