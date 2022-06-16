# frozen_string_literal: true

RSpec.describe Bs2Api::Entities::AsyncRequest do
  describe 'Object' do
    context 'attributes' do
      let(:pix_key) { build(:pix_key) }
      let(:identificator) { 'payment1' }
      let(:value) { 10.0 }

      it 'has ALLOWED_PIX_KEY_TYPES constant' do
        expect(described_class::ALLOWED_PIX_KEY_TYPES).to be_present
      end

      it 'has attr_accessor' do
        request = described_class.new(identificator, pix_key, value)

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
      let(:identificator) { 'payment1' }
      let(:value) { 10.0 }
      let(:hash_result) do
        ActiveSupport::HashWithIndifferentAccess.new(
          {
            identificator: identificator,
            chave: pix_key.to_hash,
            valor: value
          }
        )
      end

      it 'does not support phone key' do
        expect { described_class.new(identificator, phone_key, value) }.to raise_error(Bs2Api::Errors::InvalidPixKey)
      end

      it 'have mathcing attributes' do
        request = described_class.new(identificator, pix_key, value)
        expect(request.pix_key).to eq(pix_key)
        expect(request.identificator).to eq(identificator)
        expect(request.value).to eq(value)
      end

      it 'returns hash' do
        request = described_class.new(identificator, pix_key, value)
        expect(request.to_hash).to eq(hash_result)
      end

      it 'returns json' do
        request = described_class.new(identificator, pix_key, value)
        expect(request.to_json).to eq(hash_result.to_json)
      end
    end
  end
end
