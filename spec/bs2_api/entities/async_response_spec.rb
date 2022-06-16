# frozen_string_literal: true

RSpec.describe Bs2Api::Entities::AsyncResponse do
  describe 'Object' do
    context 'init' do
      let(:pix_key_value) { '74824232000109' }
      let(:pix_key_type) { 'CNPJ' }
      let(:pix_hash) do
        {
          'valor' => pix_key_value,
          'tipo' => pix_key_type
        }
      end
      let(:pix_key) { build(:pix_key, key: pix_key_value, type: pix_key_type) }
      let(:identificator) { 'payment1' }
      let(:request_id) { 'ae511cdc-d758-4545-a1d6-73c7945da53e' }
      let(:value) { 10.0 }
      let(:error) { nil }
      let(:hash_input) do
        {
          'identificador' => identificator,
          'solicitacaoId' => request_id,
          'chave' => pix_hash,
          'valor' => value,
          'error' => error
        }
      end

      it 'can be initialized via hash' do
        resp = described_class.from_hash(hash_input)
        expect(resp.identificator).to eq(hash_input['identificador'])
        expect(resp.request_id).to eq(hash_input['solicitacaoId'])
        expect(resp.pix_key.key).to eq(pix_key.key)
        expect(resp.pix_key.type).to eq(pix_key.type)
        expect(resp.value).to eq(hash_input['valor'])
        expect(resp.error).to eq(hash_input['erros'])
      end
    end
  end
end
