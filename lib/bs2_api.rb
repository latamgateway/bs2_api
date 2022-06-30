# frozen_string_literal: true

require 'httparty'
require 'active_support/core_ext/hash/indifferent_access'
require 'active_support/core_ext/hash/except'
require 'active_support/core_ext/object/to_query'
require 'active_support/core_ext/object/blank'

require 'bs2_api/version'
require 'bs2_api/configuration'

require 'bs2_api/util/response'

require 'bs2_api/errors/base'
require 'bs2_api/errors/invalid_pix_key'
require 'bs2_api/errors/invalid_bank'
require 'bs2_api/errors/invalid_customer'
require 'bs2_api/errors/missing_configuration'
require 'bs2_api/errors/unauthorized'
require 'bs2_api/errors/bad_request'
require 'bs2_api/errors/server_error'
require 'bs2_api/errors/confirmation_error'
require 'bs2_api/errors/missing_bank'

require 'bs2_api/entities/account'
require 'bs2_api/entities/bank'
require 'bs2_api/entities/customer'
require 'bs2_api/entities/payment'
require 'bs2_api/entities/pix_key'
require 'bs2_api/entities/async_request'
require 'bs2_api/entities/async_response'
require 'bs2_api/entities/async_status'

require 'bs2_api/pix/detail'

require 'bs2_api/payment/base'
require 'bs2_api/payment/key'
require 'bs2_api/payment/manual'
require 'bs2_api/payment/confirmation'
require 'bs2_api/payment/detail'
require 'bs2_api/payment/async'

require 'bs2_api/request/auth'

require 'bs2_api/refund/pix/create'
require 'bs2_api/refund/pix/detail'

module Bs2Api
  ENDPOINT = {
    production: 'https://api.bs2.com',
    sandbox: 'https://apihmz.bancobonsucesso.com.br'
  }.freeze

  class << self
    attr_writer :configuration

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end

    def endpoint
      ENDPOINT[configuration.env.to_sym]
    end

    def production?
      env == 'production'
    end

    def sandbox?
      env == 'sandbox'
    end

    def env
      configuration.env
    end
  end
end
