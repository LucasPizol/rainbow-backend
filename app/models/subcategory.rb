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

  has_many :products

  validates :name, presence: true

  before_destroy :check_for_products
  before_update :check_for_products

  def check_for_products
    if products.any?
      errors.add(:base, 'Não é possível excluir ou alterar uma subcategoria com produtos associados')

      throw :abort
    end
  end
end
