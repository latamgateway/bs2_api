module Bs2Api
  module Entities
    attr_accessor :id, :merchant_id, :receiver, :payer

    class Invoice
      def initialize(args = {})
        @id          = args.fetch(:id, nil)
        @merchant_id = args.fetch(:merchant_id, nil)
        @receiver    = args.fetch(:receiver, nil)
        @payer       = args.fetch(:payer, nil)
      end

      def to_hash
        {
          "pagamentoId": @id,
          "endToEndId": @merchant_id,
          "recebedor": @receiver.to_hash,
          "pagador": @payer.to_hash
        }
      end

      def self.from_response(hash)
        invoice = Bs2Api::Entities::Invoice.new

        invoice.id          = hash['pagamentoId']
        invoice.merchant_id = hash['endToEndId']
        invoice.receiver    = Bs2Api::Entities::Bank.from_response hash["recebedor"]
        invoice.payer       = Bs2Api::Entities::Bank.from_response hash["pagador"]

        invoice
      end
    end
  end
end

