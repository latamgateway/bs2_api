module Bs2Api
  module BankStatement
    class List
      DEFAULT_LIMIT = 512

      attr_reader :client_id, :client_secret

      def initialize(
        client_id:,
        client_secret:,
        time_range:
      )
        @client_id = client_id
        @client_secret = client_secret
        @time_range = time_range
      end

      # https://devs.bs2.com/manual/bankingv2/#tag/Conta-Corrente/paths/~1pj~1apibanking~1forintegration~1v1~1contascorrentes~1extrato/get
      def call(page: 0, limit: DEFAULT_LIMIT)
        url = "#{Bs2Api.endpoint}/pj/apibanking/forintegration/v1/contascorrentes/extrato"

        response = HTTParty.get(
          url,
          # http_proxyaddr: fixie.host,
          # http_proxyport: fixie.port,
          # http_proxyuser: fixie.user,
          # http_proxypass: fixie.password,
          headers: {
            'Content-Type' => 'application/json',
            'Accept' => 'application/json',
            'Authorization' => "Bearer #{access_token}",
          },
          query: {
            movimentoInicial: @time_range.begin.iso8601,
            movimentoFinal: @time_range.end.iso8601,
            inicio: page,
            limite: limit,
          }
        )

        raise response.body unless response.success?

        response.body
      end

      def access_token
        @access_token ||= Bs2Api::Request::Auth.token(
          client_id: @client_id,
          client_secret: @client_secret
        )
      end

      # def fixie
      #   @fixie_uri ||= URI.parse(ENV['FIXIE_URL'])
      # end
    end
  end
end
