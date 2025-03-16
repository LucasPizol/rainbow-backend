# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    password { Faker::Internet.password }
    name { Faker::Name.name }
    sequence(:email) { |n| "user#{n}@email.com" }
  end
end
