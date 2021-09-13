module Bs2Api
  module Payment
    class Detail < Base
      attr_reader :success

      def initialize payment_id
        @payment_id = payment_id
      end

      def call
        response = detail_request
        raise Bs2Api::Errors::BadRequest, ::Util::Response.parse_error(response) unless response.ok?

        Bs2Api::Entities::Payment.from_response(response)
      end

      private
        def url
          "#{Bs2Api.endpoint}/pix/direto/forintegration/v1/pagamentos/#{@payment_id}"
        end

        def detail_request
          HTTParty.get(url, headers: headers)
        end
    end
  end
end