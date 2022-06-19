# frozen_string_literal: true

FactoryBot.define do
  factory :pix_key, class: Bs2Api::Entities::PixKey do
    key { 'user@gmail.com' }
    type { 'EMAIL' }
  end
end
