module Bs2Api
  module Entities
    class Account
      attr_accessor :bank_name, :owner_name, :agency, :number, :type
  
      TYPES = {
        checking: 'ContaCorrente',
        salary: 'ContaSalario',
        saving: 'Poupanca'
      }

      def initialize(args = {})
        @bank_name  = args.fetch(:bank_name, nil)
        @owner_name = args.fetch(:owner_name, nil)
        @agency     = args.fetch(:agency, nil)
        @number     = args.fetch(:number, nil)
        @type       = args.fetch(:type, nil)
      end

      def to_hash
        {
          "banco": @bank_name,
          "bancoNome": owner_name,
          "agencia": @agency,
          "numero": @number,
          "tipo": @type
        }
      end

      def self.from_response(hash)
        account            = Bs2::Entities::Account.new
        account.bank_name  = hash["banco"]
        account.owner_name = hash["bancoNome"]
        account.agency     = hash["agencia"]
        account.number     = hash["numero"]
        account.type       = hash["tipo"]
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

    end
  end
end