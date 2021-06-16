# frozen_string_literal: true

require "bs2_api"
Bundler.require(:test)

Dotenv.load(".env.test")

VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.hook_into :webmock
  config.before_record do |i|
    i.request.headers.delete('Authorization')
  end
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

def set_configuration
  Bs2Api.configure do |config|
    config.client_id     = ENV['BS2_CLIENT_ID']
    config.client_secret = ENV['BS2_CLIENT_SECRET']
  end
end