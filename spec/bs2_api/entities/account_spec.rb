# frozen_string_literal: true

RSpec.describe Bs2Api::Entities::Account do
  describe "Object" do
    let(:hash_response) {
      {
        "banco": "123",
        "bancoNome": "Itaú",
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
        account = described_class.new

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
          bank_code: '123',
          bank_name: 'Itaú',
          agency: '456',
          number: '334',
          type: 'Poupanca'
        )
      end

      it "attributes matches" do
        expect(@account.bank_code).to eq('123')
        expect(@account.bank_name).to eq('Itaú')
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
        
        expect(account.bank_code).to eq('123')
        expect(account.bank_name).to eq('Itaú')
        expect(account.agency).to eq('456')
        expect(account.number).to eq('334')
        expect(account.type).to eq('ContaCorrente')
      end
    end
  end
end


# {
#   "pagamentoId": "aa631510-911c-47f1-9f3c-aa4c8014ec41",
#   "endToEndId": "E710278662021061120005358017675P",
#   "recebedor": {
#     "ispb": "71027866",
#     "conta": {
#       "banco": "218",
#       "bancoNome": "BCO BS2 S.A.",
#       "agencia": "0001",
#       "numero": "3134806",
#       "tipo": "ContaCorrente"
#     },
#     "pessoa": {
#       "documento": "25215188000116",
#       "tipoDocumento": "CNPJ",
#       "nome": "Teste Automatizado",
#       "nomeFantasia": null
#     }
#   },
#   "pagador": {
#     "ispb": "71027866",
#     "conta": {
#       "banco": "218",
#       "bancoNome": "BCO BS2 S.A.",
#       "agencia": "0001",
#       "numero": "3135772",
#       "tipo": "ContaCorrente"
#     },
#     "pessoa": {
#       "documento": "19183907000161",
#       "tipoDocumento": "CNPJ",
#       "nome": "latampix2_api",
#       "nomeFantasia": null
#     }
#   }
# }