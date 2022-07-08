require 'logger'
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
        proxy: nil,
        logger: Logger.new(STDOUT)
      )
        @access_token = access_token
        @time_range = time_range
        @proxy = proxy
        @logger = logger
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
          movements = fetch_page(page: page)

          break if movements.empty?

          movements.each do |movement|
            yield Entities::BankStatement.new(movement)
          end
        end
      end

      private

      def fetch_page(page:, retries: 4, retry_wait: 4)
        last_exception = nil

        retries.times do |i|
          return call(page: page).fetch(:movimentacoes)
        rescue => e
          @logger.error(e)

          last_exception = e

          sleep(retry_wait * (i + 1))

          next
        end

        raise last_exception
      end
    end
  end
end
