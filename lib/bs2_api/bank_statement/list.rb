require_relative '../entities/bank_statement'

module Bs2Api
  module BankStatement
    class List
      # This is the maximum
      DEFAULT_LIMIT = 100

      include Enumerable

      def initialize(
        access_token:,
        time_range:,
        proxy: nil
      )
        @access_token = access_token
        @time_range = time_range
        @proxy = proxy
      end

      # https://devs.bs2.com/manual/bankingv2/#tag/Conta-Corrente/paths/~1pj~1apibanking~1forintegration~1v1~1contascorrentes~1extrato/get
      def call(page: 0, limit: DEFAULT_LIMIT)
        url = "#{Bs2Api.endpoint}/pj/apibanking/forintegration/v1/contascorrentes/extrato"

        response = HTTParty.get(
          url,
          http_proxyaddr: @proxy&.host,
          http_proxyport: @proxy&.port,
          http_proxyuser: @proxy&.user,
          http_proxypass: @proxy&.password,
          headers: {
            'Content-Type' => 'application/json',
            'Accept' => 'application/json',
            'Authorization' => "Bearer #{@access_token}",
          },
          query: {
            movimentoInicial: @time_range.begin.iso8601,
            movimentoFinal: @time_range.end.iso8601,
            inicio: page,
            limite: limit,
          }
        )

        raise response.body unless response.success?

        JSON.parse(response.body, symbolize_names: true)
      end

      def each
        (0..Float::INFINITY).each do |page|
          movements = call(page: page).fetch(:movimentacoes)

          break if movements.empty?

          movements.each do |movement|
            yield Entities::BankStatement.new(movement)
          end
        end
      end
    end
  end
end
