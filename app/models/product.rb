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

class Product < ApplicationRecord
  has_paper_trail

  has_many_attached :images, dependent: :purge_later

  validates :name,
            :category_id,
            :status,
            :stock,
            :price,
            :cost_price,
            presence: true

  validates :stock, numericality: { greater_than_or_equal_to: 0 }
  validates :cost_price, numericality: { greater_than_or_equal_to: 0 }
  validates :price, numericality: { greater_than: :cost_price }

  belongs_to :category

  has_many :subcategory_products, dependent: :destroy
  has_many :subcategories, through: :subcategory_products
  has_many :stock_histories, dependent: :destroy

  before_save :generate_sku, if: -> { name_changed? }

  def generate_stock_history(quantity:)
    StockHistory.create!(
      product_id: self.id,
      quantity: quantity,
      price: self.price,
      operation: StockHistory.operations[:entry]
    )
  end

  private

  def generate_sku
    self.sku = "#{sku_formatter(self.category.name)}-"

    self.sku += "#{sku_formatter(self.name)}-#{SecureRandom.hex(2).upcase}"
  end

  def sku_formatter(content)
    content.upcase.split(" ").map { |word| word[0, 3] }.join("-")
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[name price stock sku status id]
  end
end
