# frozen_string_literal: true

require 'bs2_api/version'
require 'bs2_api/configuration'

module Bs2Api
  class Bs2ApiError < StandardError; end

  ENDPOINT = {
    production: 'https://api.bs2.com:8443',
    staging: 'https://apihmz.bancobonsucesso.com.br'
  }

  class << self
    attr_writer :configuration

    def configuration
      @configuration ||= Configuration.new
    end
  
    def configure
      yield(configuration)
    end
  end
end
