# frozen_string_literal: true

RSpec.describe Bs2Api::Entities::Customer do
  describe "Object" do
    context "attributes" do
      it "has TYPES constant" do
        expect(described_class::TYPES).to be_present
        
        expect(described_class::TYPES).to have_key(:personal)
        expect(described_class::TYPES).to have_key(:business)
      end

      it "attr_accessor" do
        customer = described_class.new

        expect(customer).to respond_to(:document)
        expect(customer).to respond_to(:type)
        expect(customer).to respond_to(:name)
        expect(customer).to respond_to(:business_name)

        expect(customer).to respond_to(:'document=')
        expect(customer).to respond_to(:'type=')
        expect(customer).to respond_to(:'name=')
        expect(customer).to respond_to(:'business_name=')
      end
    end

    context "methods" do
      let!(:hash_response) {
        {
          "documento": "25215188000116",
          "tipoDocumento": "CNPJ",
          "nome": "Teste Automatizado",
          "nomeFantasia": nil
        }
      }
      
      before do
        @customer = described_class.new(
          document: '88899988811',
          type: 'CPF',
          name: 'João Silva'
        )
      end

      it "attributes matches" do
        expect(@customer.document).to eq('88899988811')
        expect(@customer.type).to eq('CPF')
        expect(@customer.name).to eq('João Silva')
        expect(@customer.business_name).to be_blank
      end

      it "is personal" do
        expect(@customer).to be_personal
      end
      
      it "is NOT business" do
        expect(@customer).to_not be_business
      end
      
      it "to_hash has indexes" do
        hash = @customer.to_hash

        expect(hash).to have_key("documento")
        expect(hash).to have_key("tipoDocumento")
        expect(hash).to have_key("nome")
        expect(hash).to have_key("nomeFantasia")
      end

      it "from_response to return valid object" do
        customer = described_class.from_response(hash_response)

        expect(customer).to be_a(Bs2Api::Entities::Customer)
        expect(customer.document).to eq(hash_response[:documento])
        expect(customer.type).to eq(hash_response[:tipoDocumento])
        expect(customer.name).to eq(hash_response[:nome])
        expect(customer.business_name).to eq(hash_response[:nomeFantasia])
      end
    end
  end
end