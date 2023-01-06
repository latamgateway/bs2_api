# frozen_string_literal: true

module Bs2Api
  module Request
    class Auth
      DEFAULT_GRANT_TYPE = 'client_credentials'.freeze
      REFRESH_TOKEN_GRANT_TYPE = 'refresh_token'.freeze

      # TODO: See which scopes are required.
      SCOPES = [
        'saldo',
        'extrato',
        'pagamento',
        'transferencia',
        'cobv.write',
        'cobv.read',
        'comprovante',
        'webhook-mov-conta',
        'aprovacoes',
        'pagamento-tributo',
        'webhook-conclusao-transf',
        'webhook-conclusao-pag',
        'cob.write',
        'cob.read',
        'pix.write',
        'pix.read',
        'dict.write',
        'dict.read',
        'webhook.read',
        'webhook.write',
      ].map(&:freeze).freeze

      class << self
        def token(
          client_id: Bs2Api.configuration.client_id,
          client_secret: Bs2Api.configuration.client_secret,
          grant_type: DEFAULT_GRANT_TYPE,
          scopes: SCOPES
        )
          Bs2Api.configuration.valid?

          response = HTTParty.post(
                       "#{Bs2Api.endpoint}/auth/oauth/v2/token",
                       headers: {
                         "Content-Type" => "application/x-www-form-urlencoded",
                         "Accept" => "application/json",
                       },
                       body: {
                         grant_type: grant_type,
                         scope: scopes.join("\s"),
                       }.to_query,
                       basic_auth: {
                         username: client_id,
                         password: client_secret
                       }
                     )

          raise Bs2Api::Errors::Unauthorized, response['error_description'] if response.unauthorized?
          raise Bs2Api::Errors::BadRequest, response['error_description'] if response.bad_request?
          raise Bs2Api::Errors::ServerError, response.body unless response.success?

          response['access_token']
        end

        def refresh_token(
          refresh_token:,
          client_id: Bs2Api.configuration.client_id,
          client_secret: Bs2Api.configuration.client_secret,
          grant_type: REFRESH_TOKEN_GRANT_TYPE,
          scopes: SCOPES
        )
          Bs2Api.configuration.valid?

          response = HTTParty.post(
                       "#{Bs2Api.endpoint}/auth/oauth/v2/token",
                       headers: {
                         "Content-Type" => "application/x-www-form-urlencoded",
                         "Accept" => "application/json",
                       },
                       body: {
                         grant_type: grant_type,
                         scope: scopes.join("\s"),
                         refresh_token: refresh_token,
                       }.to_query,
                       basic_auth: {
                         username: client_id,
                         password: client_secret
                       }
                     )

          raise Bs2Api::Errors::Unauthorized, response['error_description'] if response.unauthorized?
          raise Bs2Api::Errors::BadRequest, response['error_description'] if response.bad_request?
          raise Bs2Api::Errors::ServerError, response.body unless response.success?

          JSON.parse(response.body, symbolize_names: true)
        end
      end
    end
  end
end
