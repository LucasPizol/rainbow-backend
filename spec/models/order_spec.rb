# == Schema Information
#
# Table name: orders
#
#  id          :integer          not null, primary key
#  customer_id :integer
#  total       :decimal(10, 2)   not null
#  status      :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_orders_on_customer_id  (customer_id)
#

require 'spec_helper'

RSpec.describe Order, type: :model do
  context 'validations' do
    it { is_expected.to validate_presence_of(:status) }
    it { is_expected.to validate_presence_of(:customer_id) }
    it { is_expected.to have_many(:order_products) }
    it { is_expected.to have_many(:products).through(:order_products) }
    it { is_expected.to accept_nested_attributes_for(:order_products) }
  end

  context 'enums' do
    it { is_expected.to define_enum_for(:status).with_values(%i[pending processing completed canceled]) }
  end

  describe '#total_price' do
    let(:order) { create(:order) }
    let(:product) { create(:product) }
    let(:order_product) { create(:order_product, order: order, product: product) }

    it { expect { order.reload.set_total_price }.to change { order.total }.from(0).to(order_product.total_price) }
  end

  Order::VALID_STATUSES.each do |status|
    describe "##{status}?" do
      let(:order) { create(:order, status: status) }

      it { expect(order.send("#{status}?")).to be_truthy }
    end
  end

  describe '#remove_from_stock' do
    let(:order) { create(:order, status: :pending) }
    let(:product) { create(:product, stock: 10) }
    let!(:order_product) { create(:order_product, order: order, product: product, quantity: 5) }

    it 'removes the quantity from the product stock' do
      order.status = :completed
      order.order_products.reload
      order.save!

      expect(product.reload.stock).to eq(5)
    end
  end
end
