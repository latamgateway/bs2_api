# frozen_string_literal: true

RSpec.describe Bs2Api::Payment::Key do
  describe "Success" do
    let!(:pix_key_hash) {
      {
        "valor": "e9e511e3-b765-4d27-abf9-03b0f9a1f3f1",
        "tipo": "EVP"
      }
    }

    let!(:pix_key) { Bs2Api::Entities::PixKey.from_response(pix_key_hash) }

    before do
      set_configuration

      VCR.use_cassette('payment/key/success') do
        @payment = described_class.new(pix_key).call
      end
    end

    it "payment was created" do
      expect(@payment).to be_a(Bs2Api::Entities::Payment)
      expect(@payment).to respond_to(:id)
      expect(@payment).to respond_to(:merchant_id)
      expect(@payment).to respond_to(:payer)
      expect(@payment).to respond_to(:receiver)
    end
  end
end