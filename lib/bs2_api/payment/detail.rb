module Bs2Api
  module Payment
    class Detail < Base
      attr_reader :success

      def initialize(
        payment_id,
        client_id: Bs2Api.configuration.client_id,
        client_secret: Bs2Api.configuration.client_secret,
        user_agent: Bs2Api.configuration.user_agent,
        proxy: nil
      )
        @payment_id = payment_id
        @client_id = client_id
        @client_secret = client_secret
        @user_agent = user_agent
        @proxy = proxy
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
        HTTParty.get(
          url, 
          headers: headers,
          http_proxyaddr: @proxy&.host,
          http_proxyport: @proxy&.port,
          http_proxyuser: @proxy&.user,
          http_proxypass: @proxy&.password
        )
      end

      def bearer_token
        Bs2Api::Request::Auth.token(
          client_id: @client_id,
          client_secret: @client_secret
        )
      end
    end
  end
end
