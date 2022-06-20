module Bs2Api
  module Payment
    class Base
      attr_reader :payment

      def initialize
        raise NoMethodError, "Missing #{__method__} to #{self.class}"
      end

      def call
        response = post_request
        raise Bs2Api::Errors::BadRequest, ::Util::Response.parse_error(response) unless response.ok?

        @payment = Bs2Api::Entities::Payment.from_response(response)
        self
      end

      private

      def post_request
        HTTParty.post(url, headers: headers, body: payload.to_json)
      end

      def headers
        {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': "Bearer #{bearer_token}"
        }
      end

      def bearer_token
        if @client_id && @client_secret
          Bs2Api::Request::Auth.token(client_id: @client_id, client_secret: @client_secret)
        else
          Bs2Api::Request::Auth.token
        end
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
