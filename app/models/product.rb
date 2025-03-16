# == Schema Information
#
# Table name: products
#
#  id             :integer          not null, primary key
#  name           :string           not null
#  description    :text
#  price          :integer          not null
#  stock          :integer          not null
#  sku            :string           not null
#  status         :string           not null
#  category_id    :integer          not null
#  subcategory_id :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_products_on_category_id     (category_id)
#  index_products_on_sku             (sku) UNIQUE
#  index_products_on_subcategory_id  (subcategory_id)
#

class Product < ApplicationRecord
  has_paper_trail

  has_many_attached :images

  validates :name,
            :category_id,
            :status,
            :stock,
            :price, presence: true

  validates :stock, numericality: { greater_than_or_equal_to: 0 }
  validates :price, numericality: { greater_than_or_equal_to: 0 }

  belongs_to :category
  belongs_to :subcategory, optional: true

  before_save :generate_sku, if: -> { name_changed? }
  before_save :format_price, if: -> { price_changed? }

  private

  def generate_sku
    self.sku = "#{sku_formatter(self.category.name)}-"
    self.sku += "#{sku_formatter(self.subcategory.name)}-" if self.subcategory.present?

    self.sku += "#{sku_formatter(self.name)}-#{SecureRandom.hex(2).upcase}"
  end

  def sku_formatter(content)
    content.upcase.split(" ").map { |word| word[0, 3] }.join("-")
  end

  def format_price
    self.price = self.price * 100
  end
end
