module Bs2Api
  module Entities
    class PixKey
      attr_accessor :id, :nickname, :value, :type

      def initialize(args = {})
        @id       = args.fetch(:id, nil)
        @nickname = args.fetch(:nickname, nil)
        @value    = args.fetch(:value, 0).to_f
        @type     = args.fetch(:type, nil)
      end

      def to_hash
        {
          "id": @id,
          "apelido": @nickname,
          "valor": @value,
          "tipo": @kind
        }
      end

      def self.from_response(hash)
        pix_key          = Bs2Api::Entities::PixKey.new
        pix_key.id       = hash["id"]
        pix_key.nickname = hash["apelido"]
        pix_key.value    = hash["valor"].to_f
        pix_key.type     = hash["tipo"]
      end
    end
  end
end