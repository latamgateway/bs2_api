module Util
  class Response
    class << self
      def parse_error res
        hash    = JSON.parse(res.body)
        message = "#{res.code}: "

        if hash.is_a?(Array)
          message << hash[0]["descricao"]
        elsif hash.key?("error_description")
          message << hash["error_description"]
        else 
          message << hash.to_s
        end

        message
      end
    end
  end
end