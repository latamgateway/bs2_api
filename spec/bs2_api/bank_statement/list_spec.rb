require_relative '../../../lib/bs2_api/bank_statement/list'

RSpec.describe Bs2Api::BankStatement::List do
  before do
    @list = Bs2Api::BankStatement::List.new(
      access_token: ENV.fetch('BS2_ACCESS_TOKEN', 'dummy'),
      time_range: (Date.today - 29).to_time.utc..(Date.today + 1).to_time.utc,
      proxy: URI.parse(ENV.fetch('FIXIE_URL'))
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
