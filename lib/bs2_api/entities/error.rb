# frozen_string_literal: true

module Bs2Api
  module Entities
    class Error
      attr_accessor :code, :description

      def initialize(args = {})
        @code        = args.fetch(:code, nil)
        @description = args.fetch(:description, nil)
      end

      def to_hash
        hash_data = {
          "erroCodigo":    @code,
          "erroDescricao": @description
        }

        ActiveSupport::HashWithIndifferentAccess.new(hash_data)
      end

      def self.from_response(hash_payload)
        return {} if hash_payload.blank?

        hash = ActiveSupport::HashWithIndifferentAccess.new(hash_payload)
        Bs2Api::Entities::Error.new(
          code: hash['erroCodigo'],
          description: hash['erroDescricao']
        )
      end
    end
  end
end
