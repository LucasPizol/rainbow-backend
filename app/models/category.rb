# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Category < ApplicationRecord
  has_paper_trail

  has_many :products

  validates :name, presence: true

  before_destroy :check_for_products
  before_update :check_for_products

  def check_for_products
    if products.any?
      errors.add(:base, 'Não é possível excluir ou alterar uma categoria com produtos associados')

      throw :abort
    end
  end
end
