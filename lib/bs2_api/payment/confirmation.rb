module Bs2Api
  module Payment
    class Confirmation < Base
      attr_reader :success

      def initialize(
        payment,
        value: nil,
        client_id: Bs2Api.configuration.client_id,
        client_secret: Bs2Api.configuration.client_secret
      )
        @client_id = client_id
        @client_secret = client_secret

        raise Bs2Api::Errors::ConfirmationError, 'invalid payment' unless payment.present? && payment.is_a?(Bs2Api::Entities::Payment)
        raise Bs2Api::Errors::ConfirmationError, 'invalid value' unless value.to_f.positive?
        @payment = payment

        @value = value.to_f
      end

      def call
        response = post_request
        raise Bs2Api::Errors::ConfirmationError, ::Util::Response.parse_error(response) unless response.accepted?

        @success = true
        self
      end

      def success?
        !!@success
      end

      private
        def payload
          @payment.to_hash
                  .except!("pagamentoId", "endToEndId")
                  .merge("valor": @value)
        end
        
        def url
          "#{Bs2Api.endpoint}/pix/direto/forintegration/v1/pagamentos/#{@payment.payment_id}/confirmacao"
        end
    end
  end
end
