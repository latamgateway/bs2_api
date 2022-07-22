# frozen_string_literal: true

module Bs2Api
  module Entities
    class Payment
      attr_accessor :payment_id, :end_to_end_id, :receiver, :payer, :status, :error

      def initialize(args = {})
        @payment_id    = args.fetch(:payment_id, nil)
        @end_to_end_id = args.fetch(:end_to_end_id, nil)
        @receiver      = args.fetch(:receiver, nil)
        @payer         = args.fetch(:payer, nil)
        @status        = args.fetch(:status, nil)
        @error         = args.fetch(:error, nil)
      end

      def to_hash
        hash_data = {
          "pagamentoId": @payment_id,
          "endToEndId":  @end_to_end_id,
          "status":      @status
        }

        hash_data.merge!({ "recebedor": @receiver.to_hash } ) if @receiver.present?
        hash_data.merge!({ "pagador": @payer.to_hash } ) if @payer.present?
        hash_data.merge!({ "erro": @error.to_hash } ) if @error.present?
        ActiveSupport::HashWithIndifferentAccess.new(hash_data)
      end

      def self.from_response(hash_payload)
        hash = ActiveSupport::HashWithIndifferentAccess.new(hash_payload)

        Bs2Api::Entities::Payment.new(
          payment_id:    hash["pagamentoId"] || hash["cobranca"]["id"],
          end_to_end_id: hash["endToEndId"],
          receiver:      Bs2Api::Entities::Bank.from_response(hash["recebedor"]),
          payer:         Bs2Api::Entities::Bank.from_response(hash["pagador"]),
          status:        hash["status"],
          error:         Bs2Api::Entities::Error.from_response(hash["erro"])
        )
      end
    end
  end
end
