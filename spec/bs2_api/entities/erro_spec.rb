# frozen_string_literal: true

RSpec.describe Bs2Api::Entities::Error do
  describe "Object" do
    let(:hash_response) {
      {
        "erroCodigo": "DS27",
        "erroDescricao": "ISPB do participante recebedor inexistente"
      }
    }

    context "attributes" do
      it "attr_accessor" do
        error = described_class.new(erro: "DS27", description: 'ISPB do participante recebedor inexistente')

        expect(error).to respond_to(:code)
        expect(error).to respond_to(:description)

        expect(error).to respond_to(:'code=')
        expect(error).to respond_to(:'description=')
      end
    end

    context "methods" do
      before do
        @error = described_class.new(
          code: "DS27",
          description: "ISPB do participante recebedor inexistente"
        )
      end

      it "attributes matches" do
        expect(@error.code).to eq('DS27')
        expect(@error.description).to eq('ISPB do participante recebedor inexistente')
      end

      it "to_hash has indexes" do
        hash = @error.to_hash

        expect(hash).to have_key("erroCodigo")
        expect(hash).to have_key("erroDescricao")
      end

      it "from response to return valid object" do
        error = described_class.from_response(hash_response)

        expect(error).to be_a(Bs2Api::Entities::Error)
        expect(error.code).to eq('DS27')
        expect(error.description).to eq('ISPB do participante recebedor inexistente')
      end
    end
  end
end
