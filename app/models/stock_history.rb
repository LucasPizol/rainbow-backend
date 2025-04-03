# == Schema Information
#
# Table name: stock_histories
#
#  id          :integer          not null, primary key
#  description :string
#  operation   :integer          not null
#  price       :decimal(10, 2)   not null
#  quantity    :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  product_id  :integer          not null
#
# Indexes
#
#  index_stock_histories_on_product_id  (product_id)
#
# Foreign Keys
#
#  product_id  (product_id => products.id)
#

class StockHistory < ApplicationRecord
  has_paper_trail

  belongs_to :product

  validates :quantity, :price, :operation, presence: true
  validates :price, numericality: { greater_than: 0 }
  validates :quantity, numericality: { greater_than: 0 }

  enum :operation, %i[entry exit]

  after_create :update_create_stock
  after_destroy :update_destroy_stock

  def update_create_stock
    if entry?
      product.stock += quantity
    else
      product.stock -= quantity
    end

    product.save!
  end

  def update_destroy_stock
    if entry?
      product.stock -= quantity
    else
      product.stock += quantity
    end

    product.save!
  end

  def self.ransackable_associations(auth_object = nil)
    ["product", "versions"]
  end
end
