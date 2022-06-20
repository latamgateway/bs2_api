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
        # @param[String] client_id ID of the client issued by BS2 used for
        # authorizatino. Optional, if not passed the default will be used
        # @param[String] client_secret The password for the account with
        # id client_id. Optional, if not passed the default will be used.
        def check_payment_status(
          request_id,
          client_id = Bs2Api.configuration.client_id,
          client_secret = Bs2Api.configuration.client_secret
        )
          url = request_status_url(request_id)
          bearer_token = Bs2Api::Request::Auth.token(
            client_id: client_id,
            client_secret: client_secret
          )
          headers = { 'Authorization': "Bearer #{bearer_token}" }
          response = HTTParty.get(url, headers: headers)
          Bs2Api::Entities::AsyncStatus.from_response response.parsed_response
        end

        private

        # The url where one can manually check the status of an async request
        #
        # @param[String] request_id The id (SolicitacaoId) for the payment
        # returned by Bs2Api::Payment::Async#call
        def request_status_url(request_id)
          "#{Bs2Api.endpoint}/pix/direto/forintegration/v1/pagamentos/chave/solicitacoes/#{request_id}"
        end
      end

      def initialize(args = {})
        @client_id = args.fetch(:client_id, Bs2Api.configuration.client_id)
        @client_secret = args.fetch(:client_secret, Bs2Api.configuration.client_secret)
        @requests = []
      end

      # Push request into the request bucker. This will not send the request.
      # When Bs2Api::Payment::Async#call is called all requeststs from the bucket
      # will be sent simultaneously
      #
      # @param[Bs2Api::Entities::AsyncRequest] The async request which is going
      # to be placed in the bucket
      def add_request(request)
        @requests << request
      end

      # Get the size of the bucket list
      def requests_count
        @requests.length
      end

      # The response from call differs from Payment::Base#call because
      # for the async method we get 202 and a list of payment transactions IDs
      # Later on we will notified via webhook for all payments transactions
      # which were successful.
      #
      # @important The API call will fail if even one of the bucket items has
      # data (PIX key, value, etc).
      #
      # @return[Hash] List of payments which we should expect to be confirmed via
      # webhook. The response will contain field "SolicitacaoId" genreated by BS2
      # this ID is used to match the payment in the webhook
      def call
        response = post_request
        raise Bs2Api::Errors::BadRequest, ::Util::Response.parse_error(response) unless response.code == 202

        response.parsed_response.map do |async_response|
          Bs2Api::Entities::AsyncResponse.from_response(async_response)
        end
      end

      private

      # The url which will be called in order to send the bucket request for processing
      def url
        "#{Bs2Api.endpoint}/pix/direto/forintegration/v1/pagamentos/chave/solicitacoes"
      end

      def payload
        {
          "solicitacoes": @requests
        }
      end
    end
  end
end
