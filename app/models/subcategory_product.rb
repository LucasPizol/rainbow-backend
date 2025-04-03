# == Schema Information
#
# Table name: subcategory_products
#
#  id             :integer          not null, primary key
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  product_id     :integer          not null
#  subcategory_id :integer          not null
#
# Indexes
#
#  index_subcategory_products_on_product_id      (product_id)
#  index_subcategory_products_on_subcategory_id  (subcategory_id)
#
# Foreign Keys
#
#  product_id      (product_id => products.id)
#  subcategory_id  (subcategory_id => subcategories.id)
#

class SubcategoryProduct < ApplicationRecord
  belongs_to :subcategory
  belongs_to :product
end
