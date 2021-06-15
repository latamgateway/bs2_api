# frozen_string_literal: true

module Bs2Api
  module Entities
    class Customer
      attr_accessor :document, :type, :name, :business_name
  
      TYPES = {
        personal: 'CPF',
        business: 'CNPJ'
      }

      def initialize(args = {})
        @document      = args.fetch(:document, nil)
        @type          = args.fetch(:type, 'CPF')
        @name          = args.fetch(:name, nil)
        @business_name = args.fetch(:business_name, nil)
      end

      def to_hash
        ActiveSupport::HashWithIndifferentAccess.new(
          {
            "documento": @document,
            "tipoDocumento": @type,
            "nome": @name,
            "nomeFantasia": @business_name
          }
        )
      end

      def self.from_response(hash_payload)
        hash = ActiveSupport::HashWithIndifferentAccess.new(hash_payload)

        Bs2Api::Entities::Customer.new(
          document: hash["documento"],
          type: hash["tipoDocumento"],
          name: hash["nome"],
          business_name: hash["nomeFantasia"]
        )
      end

      def personal?
        @type == TYPES[:personal]
      end
      
      def business?
        @type == TYPES[:business]
      end
    end
  end
end