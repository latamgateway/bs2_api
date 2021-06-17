module Bs2Api
  module Payment
    class Base
      attr_reader :payment

      def initialize
        raise NoMethodError, "Missing #{__method__} to #{self.class}"
      end

      def call
        response = post_request
        raise Bs2Api::Errors::BadRequest, Util::Response.parse_error(response) unless response.created?
        
        @payment = Bs2Api::Entities::Payment.from_response(response)
        self
      end

      private
        def post_request
          HTTParty.post(url, headers: headers, body: payload.to_json)
        end

        def headers
          {
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer #{bearer_token}"
          }
        end

        def bearer_token
          Bs2Api::Request::Auth.token
        end

        def payload
          raise NoMethodError, "Missing #{__method__} to #{self.class}"
        end
        
        def url
          raise NoMethodError, "Missing #{__method__} to #{self.class}"
        end
    end
  end
end