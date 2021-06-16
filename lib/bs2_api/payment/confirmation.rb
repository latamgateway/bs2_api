module Bs2Api
  module Payment
    class Confirmation < Base
      attr_reader :success

      def initialize payment, value: nil
        raise Bs2Api::Errors::ConfirmationError, 'invalid payment' unless payment.present? && payment.is_a?(Bs2Api::Entities::Payment)
        raise Bs2Api::Errors::ConfirmationError, 'invalid value' unless value.to_f.positive?
        @payment = payment

        @value = value.to_f
      end

      def call
        response = post_request
        raise Bs2Api::Errors::ConfirmationError, parse_error(response) unless response.accepted?

        @success = true
        self
      end

      private
        def payload
          @payment.to_hash
                  .except!("pagamentoId", "endToEndId")
                  .merge("valor": @value)
        end
        
        def url
          "#{Bs2Api.endpoint}/pix/direto/forintegration/v1/pagamentos/#{@payment.id}/confirmacao"
        end

        def success?
          !!@success
        end
    end
  end
end
