require "dotenv"
require "bs2_api"
require_relative "lib/bs2_api/request/auth.rb"

Dotenv.load(".env.test.local")

Bs2Api.configure do |config|
  config.client_id = ENV.fetch("BS2_CLIENT_ID")
  config.client_secret = ENV.fetch("BS2_CLIENT_SECRET")
end

REFRESH_TOKEN_FILE = "refresh_token.txt".freeze

refresh_token = ARGV.first || File.read(REFRESH_TOKEN_FILE)

puts "refresh_token:\s#{refresh_token.inspect}"

loop do
  puts "Geting refresh token..."

  json = Bs2Api::Request::Auth.refresh_token(refresh_token: refresh_token)

  puts json.inspect

  refresh_token = json[:refresh_token]
  expires_in = json[:expires_in]

  puts "refresh_token:\s#{refresh_token.inspect}"
  puts "expires_in:\s#{expires_in.inspect}"

  File.write(REFRESH_TOKEN_FILE, refresh_token)

  sleep_duration = expires_in - 60

  puts "Sleeping for #{sleep_duration} seconds..."

  sleep(sleep_duration)
rescue => e
  warn(e)

  sleep(5)

  retry
end
