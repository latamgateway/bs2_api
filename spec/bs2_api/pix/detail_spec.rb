require_relative '../../../lib/bs2_api/pix/detail'

RSpec.describe Bs2Api::Pix::Detail do
  before do
    @details = Bs2Api::Pix::Detail.new(
      client_id: ENV.fetch('BS2_CLIENT_ID'),
      client_secret: ENV.fetch('BS2_CLIENT_SECRET'),
      user_agent: ENV.fetch('BS2_HASH'),
      end_to_end_id: 'E710278662022061718123604409185P',
      time_range: Time.iso8601('2022-01-01T00:00:00Z')..Time.iso8601('2022-06-29T21:00:00Z'),
      proxy: fixie_proxy
    )
  end

  describe :call do
    it 'returns the pix details' do
      result = VCR.use_cassette('pix/detail/call') do
        @details.call
      end
    end
  end

  describe :details do
    it 'returns the pix details' do
      result = VCR.use_cassette('pix/detail/call') do
        @details.details
      end
    end
  end
end
