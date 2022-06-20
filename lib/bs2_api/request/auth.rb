# frozen_string_literal: true

module Bs2Api
  module Request
    class Auth
      class << self
        def token(
          client_id: Bs2Api.configuration.client_id,
          client_secret: Bs2Api.configuration.client_secret
        )
          Bs2Api.configuration.valid?

          response = create_session(client_id, client_secret)

          raise Bs2Api::Errors::Unauthorized, response['error_description'] if response.unauthorized?
          raise Bs2Api::Errors::BadRequest, response['error_description'] if response.bad_request?
          raise Bs2Api::Errors::ServerError, response.body unless response.success?

          response['access_token']
        end

        private
          def create_session(client_id, client_secret)
            HTTParty.post(
              auth_url,
              headers: headers,
              body: body,
              basic_auth: {
                username: client_id,
                password: client_secret
              }
            )
          end

          def headers
            {
              "Content-Type": "application/x-www-form-urlencoded",
              "Accept": "application/json"
            }
          end

          def body
            {
              grant_type: "client_credentials",
              scope: "pix.write pix.read"
            }.to_query
          end

          def auth_url
            "#{Bs2Api.endpoint}/auth/oauth/v2/token"
          end
     end
    end
  end
end
