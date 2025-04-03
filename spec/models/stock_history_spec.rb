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

RSpec.describe StockHistory, type: :model do
  context 'validations' do
    it { is_expected.to validate_presence_of(:quantity) }
    it { is_expected.to validate_presence_of(:price) }
    it { is_expected.to validate_presence_of(:operation) }
    it { is_expected.to validate_numericality_of(:price).is_greater_than(0) }
    it { is_expected.to validate_numericality_of(:quantity).is_greater_than(0) }

    it { is_expected.to belong_to(:product) }
  end

  context 'enums' do
    it { is_expected.to define_enum_for(:operation).with_values(%i[entry exit]) }
  end

  context 'callbacks' do
    describe '#update_create_stock' do
      let(:product) { create(:product, stock: 10) }

      context 'when the operation is entry' do
        let(:stock_history) { build(:stock_history, product: product, quantity: 5, operation: :entry) }

        it 'updates the product stock' do
          stock_history.save

          expect(product.reload.stock).to eq(15)
        end
      end

      context 'when the operation is exit' do
        let(:stock_history) { build(:stock_history, product: product, quantity: 5, operation: :exit) }

        it 'updates the product stock' do
          stock_history.save

          expect(product.reload.stock).to eq(5)
        end
      end
    end

    describe '#update_destroy_stock' do
      let(:product) { create(:product, stock: 10) }

      context 'when the operation is entry' do
        let!(:stock_history) { create(:stock_history, product: product, quantity: 5, operation: :entry) }

        it 'updates the product stock' do
          stock_history.destroy

          expect(product.reload.stock).to eq(10)
        end
      end

      context 'when the operation is exit' do
        let!(:stock_history) { create(:stock_history, product: product, quantity: 5, operation: :exit) }

        it 'updates the product stock' do
          stock_history.destroy

          expect(product.reload.stock).to eq(10)
        end
      end
    end
  end
end
