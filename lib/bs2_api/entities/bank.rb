# frozen_string_literal: true

module Bs2Api
  module Entities
    class Bank
      attr_accessor :ispb, :account, :customer

      def initialize(args = {})
        @ispb     = args.fetch(:ispb, nil)
        @account  = args.fetch(:account, nil)
        @customer = args.fetch(:customer, nil)
      end

      def to_hash
        ActiveSupport::HashWithIndifferentAccess.new(
          {
            "ispb": @ispb,
            "conta": @account.to_hash,
            "pessoa": @customer.to_hash
          }
        )
      end

      def self.from_response(hash_payload)
        return if hash_payload.blank?
        hash = ActiveSupport::HashWithIndifferentAccess.new(hash_payload)

        Bs2Api::Entities::Bank.new(
          ispb: hash["ispb"],
          account: Bs2Api::Entities::Account.from_response(hash["conta"]),
          customer: Bs2Api::Entities::Customer.from_response(hash["pessoa"])
        )
      end
    end
  end
end
