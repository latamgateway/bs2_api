module Bs2Api
  module Entities
    class PixDetail
      class Payer < Struct.new(
                      :ispb,
                      :account,
                      :person,
                      keyword_init: true
                    )
      end

      class Account < Struct.new(
                        :bank,
                        :bank_name,
                        :agency,
                        :number,
                        :type,
                        keyword_init: true
                      )
      end

      class Person < Struct.new(
                       :document,
                       :document_type,
                       :name,
                       :company_name,
                       :account,
                       keyword_init: true
                     )
      end

      attr_reader :payer

      def initialize(details)
        @details = details

        @account = Account.new(
          bank: @details.fetch(:pagador).fetch(:conta).fetch(:banco),
          bank_name: @details.fetch(:pagador).fetch(:conta).fetch(:bancoNome),
          agency: @details.fetch(:pagador).fetch(:conta).fetch(:agencia),
          number: @details.fetch(:pagador).fetch(:conta).fetch(:numero),
          type: @details.fetch(:pagador).fetch(:conta).fetch(:tipo)
        )

        @person = Person.new(
          document: @details.fetch(:pagador).fetch(:pessoa).fetch(:documento),
          document_type: @details.fetch(:pagador).fetch(:pessoa).fetch(:tipoDocumento),
          name: @details.fetch(:pagador).fetch(:pessoa).fetch(:nome),
          company_name: @details.fetch(:pagador).fetch(:pessoa).fetch(:nomeFantasia),
          account: @details.fetch(:pagador).fetch(:pessoa).fetch(:conta)
        )

        @payer = Payer.new(
          ispb: @details.fetch(:pagador).fetch(:ispb),
          account: @account,
          person: @person
        )
      end
    end
  end
end
