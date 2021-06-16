module Bs2Api
  module Payment
    class Base
      attr_reader :payment

      def initialize
        raise NoMethodError, "Missing #{__method__} to #{self.class}"
      end

      def call
        response = post_request
        raise Bs2Api::Errors::BadRequest, parse_error(response) unless response.created?
        
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

        def parse_error(response)
          hash    = JSON.parse(response.body)
          message = "#{response.code}: "

          if hash.is_a?(Array)
            message << hash[0]["descricao"]
          elsif hash.key?("error_description")
            message << hash["error_description"]
          else 
            message << hash.to_s
          end

          message
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