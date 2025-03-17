# == Schema Information
#
# Table name: customers
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  email      :string
#  phone      :string           not null
#  address    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# frozen_string_literal: true

class Customer < ApplicationRecord
  has_many :orders
  has_many :products, through: :orders

  validates :name, presence: true
  validates :phone, presence: true
end
