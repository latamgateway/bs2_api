# frozen_string_literal: true

module Bs2Api
  module Entities
    class Account
      attr_accessor :bank_code, :bank_name, :agency, :number, :type
  
      TYPES = {
        checking: 'ContaCorrente',
        salary: 'ContaSalario',
        saving: 'Poupanca'
      }

      def initialize(args = {})
        @bank_code  = args.fetch(:bank_code, nil)
        @agency     = args.fetch(:agency, nil)
        @number     = args.fetch(:number, nil)
        @type       = args.fetch(:type, nil)
        @bank_name  = get_bank_name
      end

      def to_hash
        ActiveSupport::HashWithIndifferentAccess.new(
          {
            "banco": @bank_code,
            "bancoNome": get_bank_name,
            "agencia": @agency,
            "numero": @number,
            "tipo": @type
          }
        )
      end

      def self.from_response(hash_payload)
        hash = ActiveSupport::HashWithIndifferentAccess.new(hash_payload)

        Bs2Api::Entities::Account.new(
          bank_code: hash["banco"],
          bank_name: hash["bancoNome"],
          agency: hash["agencia"],
          number: hash["numero"],
          type: hash["tipo"]
        )
      end

      def checking?
        @type == TYPES[:checking]
      end

      def salary?
        @type == TYPES[:salary]
      end

      def saving?
        @type == TYPES[:saving]
      end

      private
        def get_bank_name
          Bs2Api::Util::BankService.find_by_code(@bank_code)["name"]
        end
    end
  end
end