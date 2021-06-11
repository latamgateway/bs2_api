module Bs2Api
  module Pix
    attr_accessor :ispb, :account, :customer
    class Bank
      def initialize(args = {})
        @ispb     = args.fetch(:ispb, nil)
        @account  = args.fetch(:account, nil)
        @customer = args.fetch(:customer, nil)
      end

      def to_hash
        {
          "ispb": @ispb,
          "conta": @account.to_hash,
          "pessoa": @customer.to_hash
        }
      end

      def self.from_response(hash)
        bank          = Bs2Api::Pix::Bank.new
        bank.ispb     = hash["ispb"]
        bank.account  = Bs2Api::Account.from_response(hash["conta"])
        bank.customer = Bs2Api::Customer.from_response(hash["pessoa"])

        bank
      end
    end
  end
end