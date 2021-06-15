# frozen_string_literal: true

require 'uuid'

RSpec.describe Bs2Api::Request::Auth do
  describe "Token" do
    context "Success" do
      before do
        set_configuration
        VCR.use_cassette("request/auth/success") do
          @token = described_class.token
        end
      end
      
      it "Token is present" do
        expect(@token).to be_present
      end
      
      it "Token is valid" do
        expect(!!UUID.validate(@token)).to be_truthy
      end
    end

    context "Unauthorized" do
      before do
        Bs2Api.configure do |config|
          config.client_id     = 'wrong client id'
          config.client_secret = 'wrong client secret'
        end
      end

      it "Invalid credentials" do
        VCR.use_cassette("request/auth/invalid_credentials") do
          expect { described_class.token }.to raise_error(Bs2Api::Errors::Unauthorized, 'The given client credentials were not valid')
        end
      end
    end

    context "Bad Request" do
      before do
        set_configuration
      end

      it "Bad request" do
        VCR.use_cassette("request/auth/bad_request") do
          expect { described_class.token }.to raise_error(Bs2Api::Errors::BadRequest, 'Missing or duplicate parameters')
        end
      end
    end
  end
end