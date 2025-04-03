# == Schema Information
#
# Table name: subcategories
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_subcategories_on_name  (name) UNIQUE
#

class Subcategory < ApplicationRecord
  has_paper_trail

  has_many :subcategory_products
  has_many :products, through: :subcategory_products

  validates :name, presence: true

  before_destroy :check_for_products
  before_update :check_for_products

  def check_for_products
    if subcategory_products.any?
      errors.add(:base, 'Não é possível excluir ou alterar uma subcategoria com produtos associados')

      throw :abort
    end
  end
end
