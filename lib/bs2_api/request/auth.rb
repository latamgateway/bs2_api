# frozen_string_literal: true

module Bs2Api
  module Request
    class Auth
      class << self
        def token
          Bs2Api.configuration.valid?

          response = create_session

          raise Bs2Api::Errors::Unauthorized, response.parse["error_description"] if response.status.unauthorized?
          raise Bs2Api::Errors::BadRequest, response.parse["error_description"] if response.status.bad_request?
          raise Bs2Api::Errors::ServerError, response.body.to_s if !response.status.success?

          response.parse["access_token"]
        end

        private
          def create_session
            HTTP.basic_auth(
              user: Bs2Api.configuration.client_id,
              pass: Bs2Api.configuration.client_secret
            ).post(
              auth_url,
              body: body, 
              headers: headers
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
              scope: "pix.write%20pix.read"
            }.to_query
          end

          def auth_url
            "#{Bs2Api.endpoint}/auth/oauth/v2/token"
          end
     end
    end
  end
end