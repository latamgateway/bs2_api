# frozen_string_literal: true

require 'yaml'

module Bs2Api
  module Util
    class BankService
      class << self
        def find_by_code code
          code = code.to_s.strip.to_i
          bank = bank_list.find {|b| b["code"].to_i == code }
          raise Bs2Api::Errors::MissingBank, "Bank with code '#{code}' not registered into configuration file" if bank.blank?

          bank
        end

        def bank_list
          YAML.load_file(File.join(__dir__, 'banks.yml'))
        end
      end
    end
  end
end
