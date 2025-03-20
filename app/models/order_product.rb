# == Schema Information
#
# Table name: order_products
#
#  id         :integer          not null, primary key
#  order_id   :integer          not null
#  product_id :integer
#  quantity   :integer          not null
#  price      :decimal(10, 2)   not null
#  discount   :decimal(10, 2)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_order_products_on_order_id    (order_id)
#  index_order_products_on_product_id  (product_id)
#

# frozen_string_literal: true

class OrderProduct < ApplicationRecord
  belongs_to :order
  belongs_to :product, optional: true

  validates :price, presence: true
  validates :quantity, presence: true

  before_save :set_discount

  def total_price
    price * quantity
  end

  def set_discount
    self.discount = 0 if self.discount.nil?
  end

  def self.ransackable_attributes(auth_object = nil)
    super + ["product_id", "order_id"]
  end
end
