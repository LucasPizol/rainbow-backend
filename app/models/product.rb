# == Schema Information
#
# Table name: products
#
#  id            :integer          not null, primary key
#  name          :string           not null
#  description   :text
#  price         :decimal(10, 2)   not null
#  stock         :integer          not null
#  sku           :string           not null
#  status        :string           not null
#  category_id   :integer          not null
#  minimum_stock :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  cost_price    :decimal(10, 2)
#
# Indexes
#
#  index_products_on_category_id  (category_id)
#  index_products_on_sku          (sku) UNIQUE
#

class Product < ApplicationRecord
  has_paper_trail

  has_many_attached :images, dependent: :purge_later

  validates :name,
            :category_id,
            :status,
            :stock,
            :price, presence: true

  validates :stock, numericality: { greater_than_or_equal_to: 0 }
  validates :price, numericality: { greater_than_or_equal_to: 0 }

  belongs_to :category

  has_many :subcategory_products, dependent: :destroy
  has_many :subcategories, through: :subcategory_products

  before_save :generate_sku, if: -> { name_changed? }

  after_create :generate_stock_history

  private

  def generate_sku
    self.sku = "#{sku_formatter(self.category.name)}-"

    self.sku += "#{sku_formatter(self.name)}-#{SecureRandom.hex(2).upcase}"
  end

  def sku_formatter(content)
    content.upcase.split(" ").map { |word| word[0, 3] }.join("-")
  end

  def generate_stock_history
    StockHistory.create!(
      product_id: self.id,
      quantity: self.stock,
      price: self.price,
      operation: StockHistory.operations[:entry]
    )
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[name price stock sku status id]
  end
end
