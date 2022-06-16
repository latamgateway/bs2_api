# frozen_string_literal: true

module Bs2Api
  module Payment
    # Class used to store a bucket of requests which will be sent
    # altogether.
    class Async < Base
      class << self
        # Check the status of a request manually. Usually we will be notified
        # via webhook, but in case we do not get notification for a specific
        # payment we need to start to poll the BS2 API manually.
        #
        # @param[String] request_id The id (SolicitacaoId) for the payment
        # returned by Bs2Api::Payment::Async#call
        def check_request_status(request_id)
          url = request_status_url(request_id)
          HTTParty.get(url)
        end
      end

      def initialize
        @requests = []
      end

      def add_request(request)
        @requests << request
      end

      # The response from call differs from Payment::Base#call because
      # for the async method we get 202 and a list of payment transactions IDs
      # Later on we will notified via webhook for all payments transactions
      # which were successful.
      #
      # @return[Hash] List of payments which we should expect to be confirmed via
      # webhook. The response will contain field "SolicitacaoId" genreated by BS2
      # this ID is used to match the payment in the webhook
      def call
        response = post_request
        raise Bs2Api::Errors::BadRequest, ::Util::Response.parse_error(response) unless response.status == 202

        response.parsed_response
      end

      private

      def url
        "#{Bs2Api.endpoint}/pix/direto/forintegration/v1/pagamentos/chave/solicitacoes"
      end

      def request_status_url(request_id)
        "#{Bs2Api.endpoint}/pix/direto/forintegration/v1/pagamentos/chave/solicitacoes/#{request_id}"
      end

      def payload
        {
          "solicitacoes": @requests
        }
      end
    end
  end
end
