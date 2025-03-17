# frozen_string_literal: true

FactoryBot.define do
  factory :stock_history do
    description { Faker::Lorem.paragraph }
    price { Faker::Number.decimal(l_digits: 2) }
    quantity { Faker::Number.number(digits: 2) }
    operation { 'entry' }
    product { create(:product) }
  end
end
