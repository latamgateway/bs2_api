require_relative '../../../lib/bs2_api/bank_statement/list'

RSpec.describe Bs2Api::BankStatement::List do
  before do
    @list = Bs2Api::BankStatement::List.new(
      client_id: ENV.fetch('BS2_CLIENT_ID'),
      client_secret: ENV.fetch('BS2_CLIENT_SECRET'),
      time_range: Time.parse('2022-01-01T00:00:00Z')..Time.now.utc
    )
  end

  describe :call do
    xit 'returns the bank statements' do
      result = @list.call
      binding.pry
    rescue => e
      binding.pry
    end
  end
end
