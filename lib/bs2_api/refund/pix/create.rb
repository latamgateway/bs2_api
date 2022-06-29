# frozen_string_literal: true

module Bs2Api
  module Refund
    module Pix
      class Create
        def initialize(
         client_id:,
          client_secret:,
          end_to_end_id:,
          transaction_id:,
          value:,
          proxy: nil
        )
          @client_id = client_id
          @client_secret = client_secret
          @end_to_end_id = end_to_end_id
          @transaction_id = transaction_id
          @value = value
          @proxy = proxy
        end

        # https://devs.bs2.com/manual/pix-clientes/#tag/Devolucoes-Cliente/paths/~1pix~1direto~1forintegration~1v1~1pix~1{e2eid}~1devolucao~1{idExterno}/put
        def call
          url = "#{Bs2Api.endpoint}/pix/direto/forintegration/v1/pix/#{@end_to_end_id}/devolucao/#{@transaction_id}"

          access_token = Bs2Api::Request::Auth.token(
            client_id: @client_id,
            client_secret: @client_secret
          )

          # TODO: is PUT the right method?
          response = HTTParty.put(
            url,
            http_proxyaddr: @proxy&.host,
            http_proxyport: @proxy&.port,
            http_proxyuser: @proxy&.user,
            http_proxypass: @proxy&.password,
            headers: {
              'Content-Type' => 'application/json',
              'Accept' => 'application/json',
              'Authorization' => "Bearer #{access_token}",
            },
            body: {
              valor: value
            }.to_json
          )

          raise response.body unless response.success?

          response.body
        end
      end
    end
  end
end
