# == Schema Information
#
# Table name: orders
#
#  id          :integer          not null, primary key
#  customer_id :integer          not null
#  total       :decimal(10, 2)   not null
#  status      :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_orders_on_customer_id  (customer_id)
#

# frozen_string_literal: true

class Order < ApplicationRecord
  validates :status, presence: true
  validates :customer_id, presence: true

  before_save :set_total_price
  after_save :remove_from_stock, if: -> { completed? }

  belongs_to :customer

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
      product = order_product.product
      product.stock -= order_product.quantity
      product.save!
    end
  end
end
