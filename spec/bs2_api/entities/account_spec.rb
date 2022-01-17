# frozen_string_literal: true

RSpec.describe Bs2Api::Entities::Account do
  describe "Object" do
    let(:hash_response) {
      {
        "banco": "218",
        "bancoNome": "BANCO BS2 S.A",
        "agencia": "456",
        "numero": "334",
        "tipo": "ContaCorrente"
      }
    }

    context "attributes" do
      it "has TYPES constant" do
        expect(described_class::TYPES).to be_present
        
        expect(described_class::TYPES).to have_key(:checking)
        expect(described_class::TYPES).to have_key(:salary)
        expect(described_class::TYPES).to have_key(:saving)
      end

      it "attr_accessor" do
        account = described_class.new(bank_code: "218")

        expect(account).to respond_to(:bank_code)
        expect(account).to respond_to(:bank_name)
        expect(account).to respond_to(:agency)
        expect(account).to respond_to(:number)
        expect(account).to respond_to(:type)

        expect(account).to respond_to(:'bank_code=')
        expect(account).to respond_to(:'bank_name=')
        expect(account).to respond_to(:'agency=')
        expect(account).to respond_to(:'number=')
        expect(account).to respond_to(:'type=')
      end
    end

    context "methods" do
      before do
        @account = described_class.new(
          bank_code: '218',
          agency: '456',
          number: '334',
          type: 'Poupanca'
        )
      end

      it "attributes matches" do
        expect(@account.bank_code).to eq('218')
        expect(@account.bank_name).to eq('BANCO BS2 S.A')
        expect(@account.agency).to eq('456')
        expect(@account.number).to eq('334')
        expect(@account.type).to eq('Poupanca')
      end

      it "is saving" do
        expect(@account).to be_saving
      end
      
      it "is not checking" do
        expect(@account).to_not be_checking
      end
      
      it "is not salary" do
        expect(@account).to_not be_salary
      end

      it "to_hash has indexes" do
        hash = @account.to_hash

        expect(hash).to have_key("banco")
        expect(hash).to have_key("bancoNome")
        expect(hash).to have_key("agencia")
        expect(hash).to have_key("numero")
        expect(hash).to have_key("tipo")
      end

      it "from response to return valid object" do
        account = described_class.from_response(hash_response)

        expect(account).to be_a(Bs2Api::Entities::Account)
        
        expect(account.bank_code).to eq('218')
        expect(account.bank_name).to eq('BANCO BS2 S.A')
        expect(account.agency).to eq('456')
        expect(account.number).to eq('334')
        expect(account.type).to eq('ContaCorrente')
      end
    end
  end
end
