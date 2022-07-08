require_relative '../../../../lib/bs2_api/refund/pix/detail'

RSpec.describe Bs2Api::Refund::Pix::Detail do
  before do
    @details = Bs2Api::Refund::Pix::Detail.new(
      client_id: ENV.fetch('BS2_CLIENT_ID'),
      client_secret: ENV.fetch('BS2_CLIENT_SECRET'),
      # TODO: Use new IDs to get test cassette
      end_to_end_id: 'E710278662022061718123604409185P',
      transaction_id: 'ae1fcbc93ba6452bbc06124eab3e7fca',
      proxy: fixie_proxy
    )
  end

  describe :call do
    xit 'returns the refund details' do
      result = @details.call
    end
  end
end
