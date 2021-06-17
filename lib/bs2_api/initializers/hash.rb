# frozen_string_literal: true

class Hash
  def queryfy
    keys.map do |key|
      "#{key}=#{self[key]}"
    end.join("&")
  end
end
