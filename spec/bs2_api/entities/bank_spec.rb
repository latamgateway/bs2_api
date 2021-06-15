# frozen_string_literal: true

RSpec.describe Bs2Api::Entities::Bank do
  describe "Object" do
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

    let(:hash_response) {
      {
        "ispb": "123",
        "conta": account_response,
        "pessoa": customer_response
      }
    }

    context "attributes" do
      it "attr_accessor" do
        bank = described_class.new

        expect(bank).to respond_to(:ispb)
        expect(bank).to respond_to(:account)
        expect(bank).to respond_to(:customer)

        expect(bank).to respond_to(:'ispb=')
        expect(bank).to respond_to(:'account=')
        expect(bank).to respond_to(:'customer=')
      end
    end

    context "methods" do
      let!(:account) { Bs2Api::Entities::Account.from_response(account_response) }
      let!(:customer) { Bs2Api::Entities::Customer.from_response(customer_response) }
      
      before do
        @bank = described_class.new(
          ispb: '123',
          account: account,
          customer: customer
        )
      end

      it "attributes matches" do
        expect(@bank.ispb).to eq('123')
        expect(@bank.account).to be_a(Bs2Api::Entities::Account)
        expect(@bank.customer).to be_a(Bs2Api::Entities::Customer)
      end

      it "to_hash has indexes" do
        hash = @bank.to_hash

        expect(hash).to have_key("ispb")
        expect(hash).to have_key("conta")
        expect(hash).to have_key("pessoa")
      end

      it "from_response to return valid object" do
        bank = described_class.from_response(hash_response)

        expect(bank).to be_a(Bs2Api::Entities::Bank)
        expect(bank.account).to be_a(Bs2Api::Entities::Account)
        expect(bank.customer).to be_a(Bs2Api::Entities::Customer)
        
        expect(bank.ispb).to eq('123')
      end
    end
  end
end