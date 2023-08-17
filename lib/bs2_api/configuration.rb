# frozen_string_literal: true

class Configuration
  attr_accessor :client_id, :client_secret, :user_agent, :pix_key, :env

  def initialize
    @env           = ENV.fetch('BS2_ENVIRONMENT', 'sandbox')
    @client_id     = ENV.fetch('BS2_CLIENT_ID', nil)
    @client_secret = ENV.fetch('BS2_CLIENT_SECRET', nil)
    @user_agent    = ENV.fetch('BS2_HASH', 'Ruby')
  end

  def valid?
    raise Bs2Api::Errors::MissingConfiguration, 'Missing configuration credentials' if @client_id.blank? || @client_secret.blank?

    true
  end
end
