# == Schema Information
#
# Table name: addresses
#
#  id                   :integer          not null, primary key
#  city                 :string           not null
#  complement           :string
#  is_default           :boolean          default(FALSE), not null
#  is_invoicing_address :boolean          default(FALSE), not null
#  name                 :string           not null
#  neighborhood         :string           not null
#  number               :string           not null
#  reference            :string
#  state                :string           not null
#  street               :string           not null
#  zip_code             :string           not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  client_id            :integer          not null
#
# Indexes
#
#  index_addresses_on_client_id  (client_id)
#
# Foreign Keys
#
#  client_id  (client_id => clients.id)
#

class Address < ApplicationRecord
  belongs_to :client

  validates :street, :number, :neighborhood, :city, :state, :zip_code, presence: true

  has_many :order_requests, dependent: :destroy
end
