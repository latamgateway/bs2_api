require_relative '../../../lib/bs2_api/bank_statement/list'

RSpec.describe Bs2Api::BankStatement::List do
  before do
    @list = Bs2Api::BankStatement::List.new(
      access_token_generator: lambda { ENV.fetch('BS2_ACCESS_TOKEN', 'dummy') },
      time_range: Time.iso8601('2022-05-30T21:00:00Z')..Time.iso8601('2022-06-29T21:00:00Z'),
      proxy: fixie_proxy
    )
  end

  describe :call do
    it 'returns the bank statements' do
      result = VCR.use_cassette('bank_statement/list/call') do
        @list.call
      end
    end
  end

  describe :each do
    it 'returns the bank statements' do
      result = VCR.use_cassette('bank_statement/list/each') do
        @list.reject(&:pix?)
      end
    end
  end
end
