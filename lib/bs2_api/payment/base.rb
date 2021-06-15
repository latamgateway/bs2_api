# frozen_string_literal: true

module Bs2Api
  module Payment
    class Base
      def call
        response = HTTP.auth("Bearer #{bearer_token}")
                       .headers(headers)
                       .post(
                          url,
                          json: payload
                        )
                        
        raise Bs2Api::Errors::BadRequest, response.body.to_s if !response.status.created?
        
        Bs2Api::Entities::Payment.from_response(response.parse)
      end

      private
        def headers
          {
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Accept-Encoding": "gzip,deflate"
          }
        end

        def bearer_token
          Bs2Api::Request::Auth.token
        end

        def payload
          no_method_error
        end
        
        def url
          no_method_error
        end
        
        def no_method_error
          raise NoMethodError, "Missing #{__method__} to #{self.class}"
        end
    end
  end
end