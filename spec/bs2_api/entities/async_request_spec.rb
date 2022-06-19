# frozen_string_literal: true

RSpec.describe Bs2Api::Entities::AsyncRequest do
  describe 'Object' do
    context 'attributes' do
      let(:pix_key) { build(:pix_key) }
      let(:input_hash) { { pix_key: pix_key, identificator: 'payment1', value: 10.0 } }

      it 'has ALLOWED_PIX_KEY_TYPES constant' do
        expect(described_class::ALLOWED_PIX_KEY_TYPES).to be_present
      end

      it 'has attr_accessor' do
        request = described_class.new(input_hash)

        expect(request).to respond_to(:pix_key)
        expect(request).to respond_to(:identificator)
        expect(request).to respond_to(:value)

        expect(request).to respond_to(:'pix_key=')
        expect(request).to respond_to(:identificator=)
        expect(request).to respond_to(:'value=')
      end
    end

    context 'methods' do
      let(:pix_key) { build(:pix_key) }
      let(:phone_key) { build(:pix_key, key: '6666666', type: Bs2Api::Entities::PixKey::TYPES[:phone]) }
      let(:invalid_input) { { pix_key: phone_key, identificator: 'payment1', value: 10.0 } }
      let(:valid_input) { { pix_key: pix_key, identificator: 'payment1', value: 10.0 } }
      let(:hash_result) do
        ActiveSupport::HashWithIndifferentAccess.new(
          {
            identificador: valid_input[:identificator],
            chave: valid_input[:pix_key].to_hash,
            valor: valid_input[:value]
          }
        )
      end

      it 'does not support phone key' do
        expect { described_class.new(invalid_input) }.to raise_error(Bs2Api::Errors::InvalidPixKey)
      end

      it 'have mathcing attributes' do
        request = described_class.new(valid_input)
        expect(request.pix_key).to eq(valid_input[:pix_key])
        expect(request.identificator).to eq(valid_input[:identificator])
        expect(request.value).to eq(valid_input[:value])
      end

      it 'returns hash' do
        request = described_class.new(valid_input)
        expect(request.to_hash).to eq(hash_result)
      end

      it 'has right JSON representation' do
        request = described_class.new(valid_input)
        expect(request.to_json).to eq(hash_result.to_json)
      end
    end
  end
end
