# frozen_string_literal: true

module Bs2Api
  module Payment
    class Key < Base
      def initialize(
        key,
        client_id: Bs2Api.configuration.client_id,
        client_secret: Bs2Api.configuration.client_secret,
        user_agent: Bs2Api.configuration.user_agent,
        proxy: nil
      )
        @key = key
        @client_id = client_id
        @client_secret = client_secret
        @user_agent = user_agent
        @proxy = proxy
      end
      
      private
        def url
          "#{Bs2Api.endpoint}/pix/direto/forintegration/v1/pagamentos/chave"
        end

        def payload
          {
            "chave": @key.to_hash
          }
        end
    end
  end
end
