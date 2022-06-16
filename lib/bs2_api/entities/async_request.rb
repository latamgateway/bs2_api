# frozen_string_literal: true

module Bs2Api
  module Entities
    # Used by Bs2Api::Payment::Async. This class stores
    # PIX key, user defined identificador for the key and
    # the value to be transfered. Bs2Api::Payment::Async
    # sends a bucket of AsyncRequest and in the response
    # we get a list of passed payments. The identificador
    # can be used to keep track of the transactino in the
    # response.
    class AsyncRequest
      attr_accessor :identificator, :pix_key, :value

      ALLOWED_PIX_KEY_TYPES = %w[
        CPF
        CNPJ
        EMAIL
        EVP
      ].freeze

      def initialize(args = {})
        @pix_key = args[:pix_key]
        raise Errors::InvalidPixKey unless ALLOWED_PIX_KEY_TYPES.include? @pix_key.type

        @identificator = args.fetch(:identificator)
        @value = args[:value]
      end

      def to_hash
        ActiveSupport::HashWithIndifferentAccess.new(
          {
            identificator: @identificator,
            chave: @pix_key.to_hash,
            valor: @value
          }
        )
      end

      def to_json(*)
        to_hash.to_json
      end
    end
  end
end
