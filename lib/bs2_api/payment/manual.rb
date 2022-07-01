# frozen_string_literal: true

module Bs2Api
  module Payment
    class Manual < Base
      def initialize(
        bank,
        client_id: Bs2Api.configuration.client_id,
        client_secret: Bs2Api.configuration.client_secret
      )

        @client_id = client_id
        @client_secret = client_secret
        raise Bs2Api::Errors::InvalidBank, 'Invalid Bank' unless bank.is_a?(Bs2Api::Entities::Bank)
        @bank = bank
      end

      private
        def url
          "#{Bs2Api.endpoint}/pix/direto/forintegration/v1/pagamentos/manual"
        end

        def payload
          {
            "recebedor": @bank.to_hash
          }
        end
    end
  end
end
