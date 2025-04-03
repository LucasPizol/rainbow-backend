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

require 'spec_helper'

RSpec.describe OrderProduct, type: :model do
  context 'validations' do
    it { is_expected.to belong_to(:order) }
    it { is_expected.to belong_to(:product).optional }

    it { is_expected.to validate_presence_of(:price) }
    it { is_expected.to validate_presence_of(:quantity) }
  end
end
