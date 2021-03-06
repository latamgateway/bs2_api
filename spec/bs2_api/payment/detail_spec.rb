# frozen_string_literal: true

RSpec.describe Bs2Api::Payment::Detail do
  let!(:payment_value) { 20.00 }

  describe "Success" do
    let!(:payment_id) { 'dce166b9-fc9d-48dd-8e9f-84403a5b3ca4' }

    context "Gather payment info" do
      before do
        set_configuration
        VCR.use_cassette('payment/detail/info') do
          @payment = Bs2Api::Payment::Detail.new(payment_id).call
        end
      end

      it "instantiate a payment entity" do
        expect(@payment).to be_a(Bs2Api::Entities::Payment)
      end

      it "payment has attributes" do
        expect(@payment.payment_id).to be_present
        expect(@payment.end_to_end_id).to be_present
        expect(@payment.receiver).to be_present
        expect(@payment.payer).to be_blank # Payment is expired
      end
      
      it "payment receiver has info" do
        expect(@payment.receiver.ispb).to be_present
        expect(@payment.receiver.account).to be_present
        expect(@payment.receiver.customer).to be_present
      end

      it "payment receiver account has info" do
        expect(@payment.receiver.account.bank_code).to be_present
        expect(@payment.receiver.account.bank_name).to be_present
        expect(@payment.receiver.account.agency).to be_present
        expect(@payment.receiver.account.number).to be_present
        expect(@payment.receiver.account.type).to be_present
      end
      
      it "payment receiver customer has info" do
        expect(@payment.receiver.customer.document).to be_present
        expect(@payment.receiver.customer.type).to be_present
        expect(@payment.receiver.customer.name).to be_present
        expect(@payment.receiver.customer.business_name).to be_blank
      end
    end

    context 'custom credentials' do
      before(:all) do
        # Pollute the Bs2.configuration so that we are sure that we are
        # working with correct custom keys
        set_configuration
        Bs2Api.configuration.client_id = 'dummy'
        Bs2Api.configuration.client_secret = 'dummy'
      end

      after(:all) do
        set_configuration
      end

      it 'can work with custom credentials' do
        VCR.use_cassette('payment/detail/custom_credentials') do
          @payment = Bs2Api::Payment::Detail.new(
            payment_id,
            client_id: ENV['BS2_CLIENT_ID'],
            client_secret: ENV['BS2_CLIENT_SECRET']
          ).call
          expect(@payment).to be_a(Bs2Api::Entities::Payment)
        end
      end
    end

  end
end
