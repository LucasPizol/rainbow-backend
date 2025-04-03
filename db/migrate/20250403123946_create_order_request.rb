class CreateOrderRequest < ActiveRecord::Migration[8.0]
  def change
    create_table :order_requests do |t|
      t.references :client, null: false, foreign_key: true
      t.references :address, null: false, foreign_key: true
      t.integer    :status, null: false

      t.integer :payment_method, null: false
      t.integer :payment_status, null: false
      t.integer :shipping_status, null: false
      t.string  :tracking_number
      t.string  :tracking_url

      t.decimal :total_price, precision: 10, scale: 2, null: false, default: 0
      t.decimal :shipping_price, precision: 10, scale: 2, null: false, default: 0
      t.decimal :discount_price, precision: 10, scale: 2, null: false, default: 0

      t.timestamps
    end
  end
end
