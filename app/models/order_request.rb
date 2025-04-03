

# == Schema Information
#
# Table name: order_requests
#
#  id              :integer          not null, primary key
#  discount_price  :decimal(10, 2)   default(0.0), not null
#  payment_method  :integer          not null
#  payment_status  :integer          not null
#  shipping_price  :decimal(10, 2)   default(0.0), not null
#  shipping_status :integer          not null
#  status          :integer          not null
#  total_price     :decimal(10, 2)   default(0.0), not null
#  tracking_number :string
#  tracking_url    :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  address_id      :integer          not null
#  client_id       :integer          not null
#
# Indexes
#
#  index_order_requests_on_address_id  (address_id)
#  index_order_requests_on_client_id   (client_id)
#
# Foreign Keys
#
#  address_id  (address_id => addresses.id)
#  client_id   (client_id => clients.id)
#
class OrderRequest < ApplicationRecord
  has_many :order_request_items, dependent: :destroy

  validates :status, :payment_method, :payment_status, :shipping_status, presence: true

  enum :status, { pending: 0, processing: 1, completed: 2, canceled: 3 }
  enum :payment_method, { credit_card: 0, debit_card: 1, billet: 2, pix: 3 }
  enum :payment_status, { payment_pending: 0, payment_paid: 1, payment_failed: 2 }
  enum :shipping_status, { shipping_pending: 0, shipping_shipped: 1, shipping_delivered: 2, shipping_canceled: 3 }
end
