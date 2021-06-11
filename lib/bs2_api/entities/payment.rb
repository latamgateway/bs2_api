module Bs2Api
  module Entities
    class Payment
      attr_accessor :id, :nickname, :value, :type

      TYPES = {
        cpf: "CPF",
        cnpj: "CNPJ",
        phone: "PHONE",
        email: "EMAIL",
        evp: "EVP",
        aleatory_key: "CHAVE_ALEATORIA"
      }

      def initialize
      end
    end
  end
end