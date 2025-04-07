# == Schema Information
#
# Table name: order_products
#
#  id         :integer          not null, primary key
#  discount   :decimal(10, 2)
#  price      :decimal(10, 2)   not null
#  quantity   :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  order_id   :integer          not null
#  product_id :integer
#
# Indexes
#
#  index_order_products_on_order_id    (order_id)
#  index_order_products_on_product_id  (product_id)
#
# Foreign Keys
#
#  order_id    (order_id => orders.id)
#  product_id  (product_id => products.id)
#

# frozen_string_literal: true

class OrderProduct < ApplicationRecord
  include CheckOrderCompleted

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

  private

  def check_can_update
    raise "Cannot update order" if order.completed?
  end
end
