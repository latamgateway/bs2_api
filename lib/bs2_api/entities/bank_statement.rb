module Bs2Api
  module Entities
    class BankStatement
      class Sender < Struct.new(
                       :name,
                       :document,
                       :bank_name,
                       :bank,
                       :agency,
                       :account,
                       keyword_init: true
                     )
      end

      attr_reader :value,
                  :moved_at,
                  :protocol

      def initialize(movement)
        @movement = movement
        @value = @movement.fetch(:valor)
        @moved_at = @movement.fetch(:movimentadoEm)
        @protocol = @movement.fetch(:protocolo)
      end

      def pix?
        @movement.dig(:pix, :endToEndId)
      end

      def sender
        Sender.new(
          name: @movement.fetch(:remetente).fetch(:nome),
          document: @movement.fetch(:remetente).fetch(:documento),
          bank_name: @movement.fetch(:remetente).fetch(:nomeBanco),
          bank: @movement.fetch(:remetente).fetch(:banco),
          agency: @movement.fetch(:remetente).fetch(:agencia),
          account: @movement.fetch(:remetente).fetch(:conta)
        )
      end
    end
  end
end
