# frozen_string_literal: true

RSpec.describe Bs2Api::Entities::Payment do
  describe "Object" do
    context "attributes" do
      it "attr_accessor" do
        payment = described_class.new

        expect(payment).to respond_to(:payment_id)
        expect(payment).to respond_to(:end_to_end_id)
        expect(payment).to respond_to(:receiver)
        expect(payment).to respond_to(:payer)
        expect(payment).to respond_to(:status)
        expect(payment).to respond_to(:error_code)
        expect(payment).to respond_to(:error_message)

        expect(payment).to respond_to(:'payment_id=')
        expect(payment).to respond_to(:'end_to_end_id=')
        expect(payment).to respond_to(:'receiver=')
        expect(payment).to respond_to(:'status=')
        expect(payment).to respond_to(:'error_code=')
        expect(payment).to respond_to(:'error_message=')
      end
    end

    context "methods" do
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

      let!(:bank_response) {
        {
          "ispb": "123",
          "conta": account_response,
          "pessoa": customer_response
        }
      }

      let!(:hash_response) {
        {
          "pagamentoId": "123",
          "endToEndId": "456",
          "recebedor": bank_response,
          "pagador": bank_response
        }
      }

      let!(:receiver) { Bs2Api::Entities::Bank.from_response(bank_response) }
      let!(:payer) { Bs2Api::Entities::Bank.from_response(bank_response) }

      before do
        @payment = described_class.new(
          payment_id: "123",
          end_to_end_id: "456",
          receiver: receiver,
          payer: payer
        )
      end

      it "attributes matches" do
        expect(@payment.payment_id).to eq("123")
        expect(@payment.end_to_end_id).to eq("456")
        expect(@payment.receiver).to be_a(Bs2Api::Entities::Bank)
        expect(@payment.payer).to be_a(Bs2Api::Entities::Bank)
      end

      it "to_hash has indexes" do
        hash = @payment.to_hash

        expect(hash).to have_key("pagamentoId")
        expect(hash).to have_key("endToEndId")
        expect(hash).to have_key("recebedor")
        expect(hash).to have_key("pagador")
      end

      it "from_response to return valid object" do
        payment = described_class.from_response(hash_response)

        expect(payment).to be_a(Bs2Api::Entities::Payment)
        expect(payment.payment_id).to eq(hash_response[:pagamentoId])
        expect(payment.end_to_end_id).to eq(hash_response[:endToEndId])
        expect(payment.receiver).to be_a(Bs2Api::Entities::Bank)
        expect(payment.payer).to be_a(Bs2Api::Entities::Bank)
        expect(payment.error_code).to be_nil
        expect(payment.error_message).to be_nil
      end

      context 'with error' do
        let!(:error) {
          {
            'erroCodigo': 'DS27',
            'erroDescricao': 'ISPB do participante receberor inexistente',
          }
        }

        let!(:hash_response) {
          {
            'pagamentoId': '25bb8583-0bda-48f4-aa3f-8808585f27c2',
            'endToEndId': '456',
            'recebedor': bank_response,
            'pagador': bank_response,
            'erro': error
          }
        }

        before do
          @payment = described_class.new(
            payment_id: '25bb8583-0bda-48f4-aa3f-8808585f27c2',
            end_to_end_id: '456',
            receiver: receiver,
            payer: payer
          )
        end
        it 'from_response to return valid object' do
          payment = described_class.from_response(hash_response)

          expect(payment).to be_a(Bs2Api::Entities::Payment)
          expect(payment.payment_id).to eq(hash_response[:pagamentoId])
          expect(payment.end_to_end_id).to eq(hash_response[:endToEndId])
          expect(payment.receiver).to be_a(Bs2Api::Entities::Bank)
          expect(payment.payer).to be_a(Bs2Api::Entities::Bank)
          expect(payment.error_code).to eq(hash_response[:erro][:erroCodigo])
          expect(payment.error_message).to eq(hash_response[:erro][:erroDescricao])
        end
      end
    end
  end
end
