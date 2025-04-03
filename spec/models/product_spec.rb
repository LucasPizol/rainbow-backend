# == Schema Information
#
# Table name: products
#
#  id            :integer          not null, primary key
#  cost_price    :decimal(10, 2)
#  description   :text
#  minimum_stock :integer
#  name          :string           not null
#  price         :decimal(10, 2)   not null
#  sku           :string           not null
#  status        :string           not null
#  stock         :integer          not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  category_id   :integer          not null
#
# Indexes
#
#  index_products_on_category_id  (category_id)
#  index_products_on_sku          (sku) UNIQUE
#
# Foreign Keys
#
#  category_id  (category_id => categories.id)
#

# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Product, type: :model do
  context 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:category_id) }
    it { is_expected.to validate_presence_of(:status) }
    it { is_expected.to validate_presence_of(:stock) }
    it { is_expected.to validate_numericality_of(:stock).is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_numericality_of(:cost_price).is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_presence_of(:price) }
    it { is_expected.to have_many_attached(:images) }

    it { is_expected.to belong_to(:category) }

    it { is_expected.to have_many(:subcategory_products).dependent(:destroy) }
    it { is_expected.to have_many(:subcategories).through(:subcategory_products) }
    it { is_expected.to have_many(:stock_histories).dependent(:destroy) }
  end

  context 'callbacks' do
    describe "generate_sku" do
      let(:category) { create(:category, name: 'Category') }
      let(:product) { create(:product, category: category, name: 'Product') }

      it 'generates a sku' do
        expect(product.sku[0..7]).to eq('CAT-PRO-')
      end
    end

    describe "generate_stock_history" do
      let(:category) { create(:category, name: 'Category') }
      let(:product) { create(:product, category: category, name: 'Product') }

      it 'generates a stock history' do
        product.generate_stock_history(quantity: 10)

        expect(product.stock_histories.count).to eq(1)
      end
    end
  end
end
