module Bs2Api
  module Entities
    class Customer
      attr_accessor :document, :type, :name, :business_name
  
      TYPES ={
        personal: 'CPF',
        business: 'CNPJ'
      }

      def initialize(args = {})
        @document      = args.fetch(:document)
        @type          = args.fetch(:type)
        @name          = args.fetch(:name)
        @business_name = args.fetch(:business_name)
      end

      def to_hash
        {
          "documento": @document,
          "tipoDocumento": @type,
          "nome": @name,
          "nomeFantasia": @business_name
        }
      end

      def self.from_response(hash)
        customer               = Bs2Api::Entities::Customer.new
        customer.document      = hash["documento"]
        customer.type          = hash["tipoDocumento"]
        customer.name          = hash["nome"]
        customer.business_name = hash["nomeFantasia"]
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