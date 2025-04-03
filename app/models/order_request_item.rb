# == Schema Information
#
# Table name: order_request_items
#
#  id               :integer          not null, primary key
#  discount         :decimal(10, 2)   default(0.0), not null
#  price            :decimal(10, 2)   default(0.0), not null
#  quantity         :integer          default(1), not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  order_request_id :integer          not null
#  product_id       :integer          not null
#
# Indexes
#
#  index_order_request_items_on_order_request_id  (order_request_id)
#  index_order_request_items_on_product_id        (product_id)
#
# Foreign Keys
#
#  order_request_id  (order_request_id => order_requests.id)
#  product_id        (product_id => products.id)
#

class OrderRequestItem < ApplicationRecord
  belongs_to :order_request
  belongs_to :product

  validates :quantity, presence: true
  validates :price, presence: true
  validates :discount, presence: true
end
