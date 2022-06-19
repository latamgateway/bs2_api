# frozen_string_literal: true

RSpec.describe Bs2Api::Entities::AsyncStatus do
  describe 'Class' do
    it 'has from_response method' do
      expect(described_class).to respond_to(:from_response)
    end
  end
  describe 'Object' do
    context 'initialize' do
      let(:response) do
        {
          'solicitacaoId' => '590cc6be-5b8c-448d-b7c4-3fed3b41a170',
          'pagamentoId' => '55b4bafd-1be3-401b-ada5-4d4b0bf477c6',
          'endToEndId' => 'E710278662022030714355613110506P',
          'status' => 'Confirmado',
          'agencia' => '1',
          'numero' => '2195097',
          'chave' => {
            'valor' => '42388291828',
            'tipo' => 'CPF'
          },
          'valor' => 0.01,
          'campoLivre' => 'free field',
          'rejeitadoDescricao' => 'rejection description',
          'erroDescricao' => 'error description'
        }
      end

      it 'from response' do
        status = described_class.from_response(response)
        expect(status.request_id).to eq(response['solicitacaoId'])
        expect(status.payment_id).to eq(response['pagamentoId'])
        expect(status.end_to_end_id).to eq(response['endToEndId'])
        expect(status.status).to eq(described_class::STATUS[response['status']])
        expect(status.agency).to eq(response['agencia'])
        expect(status.number).to eq(response['numero'])
        expect(status.pix_key.key).to eq(response['chave']['valor'])
        expect(status.pix_key.type).to eq(response['chave']['tipo'])
        expect(status.value).to eq(response['valor'])
        expect(status.free_field).to eq(response['campoLivre'])
        expect(status.rejection_description).to eq(response['rejeitadoDescricao'])
        expect(status.error_description).to eq(response['erroDescricao'])
      end
    end

    context 'confirmed response' do
      let(:confirmed_response) do
        {
          'solicitacaoId' => '590cc6be-5b8c-448d-b7c4-3fed3b41a170',
          'pagamentoId' => '55b4bafd-1be3-401b-ada5-4d4b0bf477c6',
          'endToEndId' => 'E710278662022030714355613110506P',
          'status' => 'Confirmado',
          'agencia' => '1',
          'numero' => '2195097',
          'chave' => {
            'valor' => '42388291828',
            'tipo' => 'CPF'
          },
          'valor' => 0.01,
          'campoLivre' => 'free field',
          'rejeitadoDescricao' => 'rejection description',
          'erroDescricao' => 'error description'
        }
      end

      it 'is conifrmed' do
        status = described_class.from_response(confirmed_response)
        expect(status.confirmed?).to be(true)
      end
    end

    context 'rejected response' do
      let(:rejected_response) do
        {
          'solicitacaoId' => '590cc6be-5b8c-448d-b7c4-3fed3b41a170',
          'pagamentoId' => '55b4bafd-1be3-401b-ada5-4d4b0bf477c6',
          'endToEndId' => 'E710278662022030714355613110506P',
          'status' => 'Rejeitado',
          'agencia' => '1',
          'numero' => '2195097',
          'chave' => {
            'valor' => '42388291828',
            'tipo' => 'CPF'
          },
          'valor' => 0.01,
          'campoLivre' => 'free field',
          'rejeitadoDescricao' => 'rejection description',
          'erroDescricao' => 'error description'
        }
      end

      it 'is rejected' do
        status = described_class.from_response(rejected_response)
        expect(status.rejected?).to be(true)
      end
    end
  end
end
