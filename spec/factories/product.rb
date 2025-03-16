# frozen_string_literal: true

FactoryBot.define do
  factory :product do
    name { Faker::Name.name }
    description { Faker::Lorem.paragraph }
    price { Faker::Number.decimal(l_digits: 2) }
    stock { Faker::Number.number(digits: 2) }
    status { 'active' }
    category { create(:category) }
    subcategory { create(:subcategory) }
  end
end
