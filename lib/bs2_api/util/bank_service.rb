# frozen_string_literal: true

require 'yaml'

module Bs2Api
  module Util
    class BankService
      class << self
        def find_by_code code
          bank_list.find {|b| b["code"] == code }
        end

        private
          def bank_list
            @bank_list ||= YAML.load_file(File.join(__dir__, 'banks.yml'))
          end
      end
    end
  end
end