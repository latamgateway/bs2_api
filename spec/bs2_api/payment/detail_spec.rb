# frozen_string_literal: true

RSpec.describe Bs2Api::Payment::Detail do
  let!(:payment_value) { 20.00 }

  describe "Success" do
    let!(:payment_id) { 'dce166b9-fc9d-48dd-8e9f-84403a5b3ca4' }
    
    before do
      set_configuration
    end

    context "Gather payment info" do
      it "instantiate a payment entity" do
        VCR.use_cassette('payment/detail/info') do
          payment = Bs2Api::Payment::Detail.new(payment_id).call
          expect(payment).to be_a(Bs2Api::Entities::Payment)
        end
      end
    end
  end
end