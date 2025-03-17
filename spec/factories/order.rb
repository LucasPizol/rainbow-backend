# frozen_string_literal: true

FactoryBot.define do
  factory :order do
    customer { create(:customer) }
    status { 1 }
    total { 100 }
  end
end
