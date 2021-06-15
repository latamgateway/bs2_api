# frozen_string_literal: true

class Hash
  def to_query
    keys.map do |key|
      "#{key}=#{self[key]}"
    end.join("&")
  end
end
