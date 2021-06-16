# frozen_string_literal: true

RSpec.describe Bs2Api::Payment::Key do
  describe "Success" do
    let!(:pix_key_hash) {
      {
        "valor": ENV['BS2_EVP_TEST_KEY'],
        "tipo": "EVP"
      }
    }

    let!(:pix_key) { Bs2Api::Entities::PixKey.from_response(pix_key_hash) }

    before do
      set_configuration

      VCR.use_cassette('payment/key/success') do
        @key_payment = described_class.new(pix_key).call
      end
    end

    it "payment was created" do
      expect(@key_payment.payment).to be_a(Bs2Api::Entities::Payment)
      expect(@key_payment.payment).to respond_to(:id)
      expect(@key_payment.payment).to respond_to(:merchant_id)
      expect(@key_payment.payment).to respond_to(:payer)
      expect(@key_payment.payment).to respond_to(:receiver)
    end
  end

  describe "Error" do
    let!(:invalid_key) {
      {
        "valor": "invalid",
        "tipo": "EVP"
      }
    }

    let!(:pix_key) { Bs2Api::Entities::PixKey.from_response(invalid_key) }

    before do
      set_configuration
    end
    
    it "raise Error" do
      VCR.use_cassette('payment/key/invalid_key', :preserve_exact_body_bytes => true) do
        expect { described_class.new(pix_key).call }.to raise_error(Bs2Api::Errors::BadRequest, '400: O formato esperado não foi respeitado.')
      end
    end
  end
end