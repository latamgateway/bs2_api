# frozen_string_literal: true

module Bs2Api
  module Entities
    class Payment
      attr_accessor :id, :merchant_id, :receiver, :payer

      def initialize(args = {})
        @id          = args.fetch(:id, nil)
        @merchant_id = args.fetch(:merchant_id, nil)
        @receiver    = args.fetch(:receiver, nil)
        @payer       = args.fetch(:payer, nil)
      end

      def to_hash
        ActiveSupport::HashWithIndifferentAccess.new(
          {
            "pagamentoId": @id,
            "endToEndId": @merchant_id,
            "recebedor": @receiver.to_hash,
            "pagador": @payer.to_hash
          }
        )
      end

      def self.from_response(hash_payload)
        hash = ActiveSupport::HashWithIndifferentAccess.new(hash_payload)

        Bs2Api::Entities::Payment.new(
          id: hash["pagamentoId"],
          merchant_id: hash["endToEndId"],
          receiver: Bs2Api::Entities::Bank.from_response(hash["recebedor"]),
          payer: Bs2Api::Entities::Bank.from_response(hash["pagador"])
        )
      end
    end
  end
end