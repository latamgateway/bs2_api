# frozen_string_literal: true

class Configuration
  attr_accessor :client_id, :client_secret, :pix_key, :env

  def initialize
    @env           = ENV.fetch('BS2_ENVIRONMENT', 'sandbox')
    @client_id     = ENV.fetch('BS2_CLIENT_ID', nil)
    @client_secret = ENV.fetch('BS2_CLIENT_SECRET', nil)
  end

  def valid?
    raise Bs2Api::Errors::MissingConfiguration, 'Missing configuration credentials' if @client_id.blank? || @client_secret.blank?
  end
end