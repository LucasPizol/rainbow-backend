# == Schema Information
#
# Table name: subcategory_products
#
#  id             :integer          not null, primary key
#  subcategory_id :integer          not null
#  product_id     :integer          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_subcategory_products_on_product_id      (product_id)
#  index_subcategory_products_on_subcategory_id  (subcategory_id)
#

# frozen_string_literal: true

FactoryBot.define do
  factory :subcategory_product do
    subcategory { create(:subcategory) }
    product { create(:product) }
  end
end
