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

require 'spec_helper'

RSpec.describe OrderProduct, type: :model do
  context 'validations' do
    it { is_expected.to belong_to(:order) }
    it { is_expected.to belong_to(:product).optional }

    it { is_expected.to validate_presence_of(:price) }
    it { is_expected.to validate_presence_of(:quantity) }
  end
end
