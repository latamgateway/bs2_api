# frozen_string_literal: true

RSpec.describe Bs2Api::Payment::Async do
  describe 'Object' do
    it 'has API methods' do
      async_payment = described_class.new
      expect(described_class).to respond_to(:check_request_status)
      expect(async_payment).to respond_to(:add_request)
      expect(async_payment).to respond_to(:requests_count)
      expect(async_payment).to respond_to(:call)
    end

    context 'empty' do
      let(:empty_object) { described_class.new }

      it 'has zero length' do
        expect(empty_object.requests_count).to eq(0)
      end

      it 'throws exception on call' do
        VCR.use_cassette('payment/async/empty') do
          expect { empty_object.call }.to raise_error(Bs2Api::Errors::BadRequest)
        end
      end
    end

    context 'with correct keys' do
      let(:pix_key) do
        build(
          :pix_key,
          type: Bs2Api::Entities::PixKey::TYPES[:cnpj],
          key: '74824232000109'
        )
      end

      let(:async_request) do
        build(
          :async_request,
          pix_key: pix_key,
          value: 10.0,
          identificator: 'Rquest (cnpj)'
        )
      end

      before do
        @async_payment = described_class.new
      end

      it 'has correct request count' do
        expect(@async_payment.requests_count).to eq(0)

        @async_payment.add_request(async_request)
        expect(@async_payment.requests_count).to eq(1)

        @async_payment.add_request(async_request)
        expect(@async_payment.requests_count).to eq(2)
      end

      it 'has correct response' do
        @async_payment.add_request(async_request)

        VCR.use_cassette('payment/async/correct') do
          response_list = @async_payment.call
          expect(response_list.is_a?(Array)).to be(true)
          expect(response_list.length).to eq(@async_payment.requests_count)

          response = response_list[0]
          expect(response.is_a?(Bs2Api::Entities::AsyncResponse)).to be(true)
          expect(response.identificator).to eq(async_request.identificator)
          expect(response.value).to eq(async_request.value)
          expect(response.pix_key.key).to eq(pix_key.key)
          expect(response.pix_key.type).to eq(pix_key.type)
        end
      end

      it 'can check status manually' do
        @async_payment.add_request(async_request)
        VCR.use_cassette('payment/async/correct') do
          response_list = @async_payment.call
          response = response_list[0]
          VCR.use_cassette('payment/async/correct/status') do
            described_class.check_request_status(response.request_id)
          end
        end
      end
    end
  end
end
