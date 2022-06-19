# frozen_string_literal: true

module Bs2Api
  module Entities
    # Used with Bs2Api::Payment::Async. When we call
    # Bs2Api::Payment::Async#call we expect to get data for each
    # item in the bucket via webhook. If we don't get webhooks in
    # a few seconds (roughly about 10s) we should start polling the
    # status of the payment by calling # Bs2Api::Payment::Async::check_payment_status.
    # The following # class is used to wrap the result of
    # Bs2Api::Payment::Async::check_payment_status
    class AsyncStatus
      attr_accessor :request_id, :payment_id, :end_to_end_id, :status,
                    :agency, :number, :pix_key, :value, :free_field,
                    :rejection_description, :error_description

      class << self
        # Parses the has from the response body of
        # Bs2Api::Payment::Async::check_payment_status
        # @param[Hash] The response body as a hash with string keys
        def from_response(hash)
          byebug
          self.new(
            request_id: hash['solicitacaoId'],
            payment_id: hash['pagamentoId'],
            end_to_end_id: hash['end_to_end_id'],
            status: hash['status'],
            agency: hash['agencia'],
            number: hash['number'],
            pix_key: Bs2Api::Entities::PixKey.from_response(hash['chave']),
            valor: hash['valor'],
            free_field: hash['campoLivre'],
            rejection_description: hash['rejeitadoDescricao'],
            error_description: hash['erroDescricao']
          )
        end
      end

      def initialize(args = {})
        @request_id = args[:request_id]
        @payment_id = args[:payment_id]
        @end_to_end_id = args[:end_to_end_id]
        @status = args[:status]
        @agency = args[:agency]
        @number = args[:number]
        @pix_key = args[:pix_key]
        @value = args[:value]
        @free_field = args[:free_field]
        @rejection_description = args[:rejection_description]
        @error_description = args[:error_description]
      end
    end
  end
end
