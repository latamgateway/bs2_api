# frozen_string_literal: true

RSpec.describe Bs2Api::Payment::Confirmation do
  let!(:payment_value) { 20.00 }

  describe "Error" do
    let!(:account_response) {
      {
        "banco": "218",
        "bancoNome": "BCO BS2 S.A.",
        "agencia": "0001",
        "numero": "3134806",
        "tipo": "ContaCorrente"
      }
    }
  
    let!(:customer_response) {
      {
        "documento": "25215188000116",
        "tipoDocumento": "CNPJ",
        "nome": "Teste Automatizado",
        "nomeFantasia": nil
      }
    }
  
    let!(:payer_response) {
      {
        "ispb": "71027866",
        "conta": account_response,
        "pessoa": customer_response
      }
    }
  
    let!(:receiver_response) {
      {
        "ispb": "71027866",
        "conta": account_response,
        "pessoa": customer_response
      }
    }
    
    let!(:hash_response) {
      {
        "pagamentoId": "dce166b9-fc9d-48dd-8e9f-84403a5b3ca4",
        "endToEndId": "456",
        "recebedor": receiver_response,
        "pagador": payer_response
      }
    }

    let!(:payment) { Bs2Api::Entities::Payment.from_response(hash_response) }

    before do
      set_configuration
    end

    context "expired" do
      it "raise error" do
        VCR.use_cassette('payment/confirmation/expired') do
          expect { described_class.new(payment, value: payment_value).call }.to raise_error(Bs2Api::Errors::ConfirmationError, "400: Pagamento não está disponível para confirmação. Status atual: EXPIRADO")
        end
      end
    end
  end
    
  describe "Success" do
    let!(:pix_key) { Bs2Api::Entities::PixKey.new(key: ENV['BS2_EVP_TEST_KEY'], type: "EVP") }

    before do
      VCR.use_cassette('payment/confirmation/success') do
        pay_key = Bs2Api::Payment::Key.new(pix_key).call
        @manual_payment = described_class.new(pay_key.payment, value: payment_value).call
      end
    end

    it "payment was created" do
      expect(@manual_payment.payment).to be_a(Bs2Api::Entities::Payment)
      expect(@manual_payment.payment).to respond_to(:payment_id)
      expect(@manual_payment.payment).to respond_to(:end_to_end_id)
      expect(@manual_payment.payment).to respond_to(:payer)
      expect(@manual_payment.payment).to respond_to(:receiver)
    end      
  end
end