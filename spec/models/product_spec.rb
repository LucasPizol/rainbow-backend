# == Schema Information
#
# Table name: products
#
#  id             :integer          not null, primary key
#  name           :string           not null
#  description    :text
#  price          :decimal(10, 2)   not null
#  stock          :integer          not null
#  sku            :string           not null
#  status         :string           not null
#  category_id    :integer          not null
#  subcategory_id :integer
#  minimum_stock  :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_products_on_category_id     (category_id)
#  index_products_on_sku             (sku) UNIQUE
#  index_products_on_subcategory_id  (subcategory_id)
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
    it { is_expected.to validate_numericality_of(:price).is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_presence_of(:price) }

    it { is_expected.to have_many_attached(:images) }

    it { is_expected.to belong_to(:category) }
    it { is_expected.to belong_to(:subcategory).optional }
  end

  context 'callbacks' do
    describe "generate_sku" do
      let(:category) { create(:category, name: 'Category') }
      let(:subcategory) { create(:subcategory, name: 'Subcategory') }
      let(:product) { create(:product, category: category, subcategory: subcategory, name: 'Product') }

      it 'generates a sku' do
        expect(product.sku[0..11]).to eq('CAT-SUB-PRO-')
      end
    end
  end
end
