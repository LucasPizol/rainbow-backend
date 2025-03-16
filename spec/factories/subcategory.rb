# frozen_string_literal: true

FactoryBot.define do
  factory :subcategory do
    name { Faker::Name.name }
  end
end
