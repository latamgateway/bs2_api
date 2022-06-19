# frozen_string_literal: true

module Bs2Api
  module Entities
    class PixKey
      attr_accessor :key, :type

      TYPES = {
        cpf: 'CPF',
        cnpj: 'CNPJ',
        phone: 'PHONE',
        email: 'EMAIL',
        random: 'EVP'
      }.freeze

      def initialize(args = {})
        @key = args.fetch(:key, nil)
        @type = args.fetch(:type, 'CPF')
      end

      def to_hash
        ActiveSupport::HashWithIndifferentAccess.new(
          {
            "valor": @key,
            "tipo": @type
          }
        )
      end

      def self.from_response(hash_payload)
        hash = ActiveSupport::HashWithIndifferentAccess.new(hash_payload)
        
        Bs2Api::Entities::PixKey.new(
          key: hash["valor"],
          type: hash["tipo"]
        )
      end
    end
  end
end
