require_relative '../entities/pix_detail'

module Bs2Api
  module Pix
    class Detail
      def initialize(
        client_id:,
        client_secret:,
        user_agent:,
        end_to_end_id:,
        time_range:,
        transaction_id: nil,
        proxy: nil
      )
        @client_id = client_id
        @client_secret = client_secret
        @user_agent = user_agent
        @end_to_end_id = end_to_end_id
        @time_range = time_range
        @transaction_id = transaction_id
        @proxy = proxy
      end

      def call
        url = "#{Bs2Api.endpoint}/pix/direto/forintegration/v1/recebimentos/#{@end_to_end_id}/recebimento"
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
          },
          query: {
            Inicio: @time_range.begin.iso8601,
            Fim: @time_range.end.iso8601,
            TxId: @transaction_id,
          }
        )

        raise response.body unless response.success?

        JSON.parse(response.body, symbolize_names: true)
      end

      def details
        Entities::PixDetail.new(call)
      end
    end
  end
end
