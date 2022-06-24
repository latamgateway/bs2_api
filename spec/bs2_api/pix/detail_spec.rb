require_relative '../../../lib/bs2_api/pix/detail'

RSpec.describe Bs2Api::Pix::Detail do
  before do
    @details = Bs2Api::Pix::Detail.new(
      client_id: ENV.fetch('BS2_CLIENT_ID'),
      client_secret: ENV.fetch('BS2_CLIENT_SECRET'),
      end_to_end_id: 'E710278662022061718123604409185P',
      time_range: Time.parse('2022-01-01T00:00:00Z')..Time.now.utc
    )
  end

  describe :call do
    xit 'returns the pix details' do
      result = @details.call
      binding.pry
    rescue => e
      binding.pry
    end
  end
end
