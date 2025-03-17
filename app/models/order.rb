# == Schema Information
#
# Table name: orders
#
#  id          :integer          not null, primary key
#  customer_id :integer          not null
#  total       :integer          not null
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

  belongs_to :customer

  has_many :order_products
  has_many :products, through: :order_products

  accepts_nested_attributes_for :order_products, allow_destroy: false

  VALID_STATUSES = %w(pending processing completed canceled).freeze

  enum :status, VALID_STATUSES.map.with_index { |status, i| [status.to_sym, i] }.to_h

  def set_total_price
    self.total = order_products.sum(&:total_price)
  end
end
