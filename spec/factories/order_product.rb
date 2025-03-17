# frozen_string_literal: true

FactoryBot.define do
  factory :order_product do
    order { create(:order) }
    product { create(:product) }
    quantity { 1 }
    price { 100 }
    discount { 0 }
  end
end
