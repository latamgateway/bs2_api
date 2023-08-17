module Bs2Api
  module Refund
    module Pix
      class Detail
        STATUSES = {
          'EM_PROCESSAMENTO' => :processing,
          'DEVOLVIDO' => :refunded,
          'NAO_REALIZADO' => :not_achieved,
        }.freeze

        def initialize(
          client_id:,
          client_secret:,
          user_agent:,
          end_to_end_id:,
          transaction_id:,
          proxy: nil
        )
          @client_id = client_id
          @client_secret = client_secret
          @user_agent = user_agent
          @end_to_end_id = end_to_end_id
          @transaction_id = transaction_id
          @proxy = proxy
        end

        # https://devs.bs2.com/manual/pix-clientes/#tag/Devolucoes-Cliente/paths/~1pix~1direto~1forintegration~1v1~1pix~1{e2eid}~1devolucao~1{idExterno}/get
        def call
          url = "#{Bs2Api.endpoint}/pix/direto/forintegration/v1/pix/#{@end_to_end_id}/devolucao/#{@transaction_id}"

          access_token = Bs2Api::Request::Auth.token(
            client_id: @client_id,
            client_secret: @client_secret
          )

          response = HTTParty.get(
            url,
            http_proxyaddr: @proxy&.host,
            http_proxyport: @proxy&.port,
            http_proxyuser: @proxy&.user,
            http_proxypass: @proxy&.password,
            headers: {
              'Content-Type' => 'application/json',
              'Accept' => 'application/json',
              'Authorization' => "Bearer #{access_token}",
              'User-Agent' => @user_agent,
            }
          )

          raise response.body unless response.success?

          JSON.parse(response.body)
        end

        def status
          @status ||= STATUSES.fetch(call.fetch('status'))
        end
      end
    end
  end
end
