# == Schema Information
#
# Table name: cart_items
#
#  id         :integer          not null, primary key
#  quantity   :integer          default(1)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  client_id  :integer          not null
#  product_id :integer          not null
#
# Indexes
#
#  index_cart_items_on_client_id   (client_id)
#  index_cart_items_on_product_id  (product_id)
#
# Foreign Keys
#
#  client_id   (client_id => clients.id)
#  product_id  (product_id => products.id)
#
class CartItem < ApplicationRecord
  belongs_to :product
  belongs_to :client

  validates :quantity, presence: true
  validates :quantity, numericality: { greater_than: 0 }

  def total_price
    product.price * quantity
  end
end
