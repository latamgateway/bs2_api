# frozen_string_literal: true

RSpec.describe Bs2Api::Util::BankService do
  describe "Methods" do
    context "find_by_code" do
      it "as string" do
        expect(described_class.find_by_code("77")).to be_present
      end
      
      it "with 0 prefix as string" do
        expect(described_class.find_by_code("077")).to be_present
      end
      
      it "as integer" do
        expect(described_class.find_by_code(77)).to be_present
      end
      
      it "empty" do
        expect { described_class.find_by_code("") }.to raise_error(Bs2Api::Errors::MissingBank)
      end
      
      it "nil" do
        expect { described_class.find_by_code(nil) }.to raise_error(Bs2Api::Errors::MissingBank)
      end
    end
  end
end
