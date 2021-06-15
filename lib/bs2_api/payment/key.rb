# frozen_string_literal: true

module Bs2Api
  module Payment
    class Key < Base
      def initialize key
        @key = key
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
