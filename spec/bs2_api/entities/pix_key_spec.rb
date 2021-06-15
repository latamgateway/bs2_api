# frozen_string_literal: true

RSpec.describe Bs2Api::Entities::PixKey do
  describe "Object" do
    context "attributes" do
      it "has TYPES constant" do
        expect(described_class::TYPES).to be_present
        
        expect(described_class::TYPES).to have_key(:cpf)
        expect(described_class::TYPES).to have_key(:cnpj)
        expect(described_class::TYPES).to have_key(:phone)
        expect(described_class::TYPES).to have_key(:email)
        expect(described_class::TYPES).to have_key(:random)
      end

      it "attr_accessor" do
        payment = described_class.new

        expect(payment).to respond_to(:key)
        expect(payment).to respond_to(:type)

        expect(payment).to respond_to(:'key=')
        expect(payment).to respond_to(:'type=')
      end
    end

    context "methods" do
      let!(:hash_response) {
        {
          "valor": "joao@gmail.com",
          "tipo": "EMAIL"
        }
      }
      
      before do
        @pix_key = described_class.new(
          key: "joao@gmail.com",
          type: "EMAIL"
        )
      end

      it "attributes matches" do
        expect(@pix_key.key).to eq("joao@gmail.com")
        expect(@pix_key.type).to eq("EMAIL")
      end

      it "to_hash has indexes" do
        hash = @pix_key.to_hash

        expect(hash).to have_key("valor")
        expect(hash).to have_key("tipo")
      end

      it "from_response to return valid object" do
        pix_key = described_class.from_response(hash_response)

        expect(pix_key).to be_a(Bs2Api::Entities::PixKey)
        expect(pix_key.key).to eq(hash_response[:valor])
        expect(pix_key.type).to eq(hash_response[:tipo])
      end
    end
  end
end