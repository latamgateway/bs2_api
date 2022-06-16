# frozen_string_literal: true

module Bs2Api
  module Entities
    # After we send async payment request via calling Bs2Api::Payment::Async#call
    # the API is expected to return array of JSON objects describing each payment
    # this class is used to wrap those JSON objects
    # identificator is optional and is for internal purposes it won't be sent via
    # the webhook when the payment confirmation is done.
    # request_id is the id of the payment which the bank will send via webhook
    class AsyncResponse
      attr_accessor :identificator, :pix_key, :value, :error, :request_id

      class << self
        def from_hash(input_hash)
          pix_key = PixKey.new(
            key: input_hash['chave']['valor'],
            type: input_hash['chave']['tipo']
          )
          AsyncResponse.new(
            identificator: input_hash['identificador'],
            pix_key: pix_key,
            value: input_hash['valor'],
            error: input_hash['erros'],
            request_id: input_hash['solicitacaoId']
          )
        end
      end

      def initialize(args = {})
        @identificator = args.fetch(:identificator, '')
        @pix_key = args[:pix_key]
        @value = args[:value]
        @error = args[:error]
        @request_id = args[:request_id]
      end

    end
  end
end
