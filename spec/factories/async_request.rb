# frozen_string_literal: true

FactoryBot.define do
  factory :async_request, class: Bs2Api::Entities::AsyncRequest do
    pix_key
    value { 10.0 }
    identificator { 'dummy' }

    initialize_with { new({pix_key: pix_key, value: value, identificator: identificator}) }
  end
end
