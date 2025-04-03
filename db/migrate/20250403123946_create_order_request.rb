class CreateOrderRequest < ActiveRecord::Migration[8.0]
  def change
    create_table :order_requests do |t|
      t.references :client, null: false, foreign_key: true
      t.references :address, null: false, foreign_key: true
      t.references :payment_method, null: false, foreign_key: true
      t.references :status, null: false, foreign_key: true
      t.references :payment_status, null: false, foreign_key: true
      t.references :shipping_status, null: false, foreign_key: true

      t.decimal :total_price, precision: 10, scale: 2
      t.decimal :shipping_price, precision: 10, scale: 2
      t.decimal :discount_price, precision: 10, scale: 2

      t.string :tracking_number
      t.string :tracking_url

      t.timestamps
    end
  end
end
