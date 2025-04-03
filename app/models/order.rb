# == Schema Information
#
# Table name: orders
#
#  id          :integer          not null, primary key
#  status      :integer          not null
#  total       :decimal(10, 2)   not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  customer_id :integer
#
# Indexes
#
#  index_orders_on_customer_id  (customer_id)
#
# Foreign Keys
#
#  customer_id  (customer_id => customers.id)
#

# frozen_string_literal: true

class Order < ApplicationRecord
  validates :status, presence: true

  before_save :set_total_price
  before_update :remove_from_stock, if: -> { completed? }

  belongs_to :customer, optional: true

  has_many :order_products
  has_many :products, through: :order_products

  accepts_nested_attributes_for :order_products, allow_destroy: false

  VALID_STATUSES = %w(pending processing completed canceled).freeze

  enum :status, VALID_STATUSES.map.with_index { |status, i| [status.to_sym, i] }.to_h

  def set_total_price
    self.total = order_products.sum(&:total_price)
  end

  VALID_STATUSES.each do |status|
    define_method "#{status}?" do
      self.status == status
    end
  end

  def remove_from_stock
    order_products.each do |order_product|
      StockHistory.create!(
        product_id: order_product.product_id,
        quantity: order_product.quantity,
        price: order_product.price,
        operation: StockHistory.operations[:exit]
      )
    end
  end

  def self.ransackable_attributes(auth_object = nil)
    super + ["id", "status", "total"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["customer", "order_products", "products"]
  end
end
