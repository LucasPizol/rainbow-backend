class CreateOrderRequestItem < ActiveRecord::Migration[8.0]
  def change
    create_table :order_request_items do |t|
      t.references :order_request, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.integer    :quantity, null: false, default: 1
      t.decimal    :price, precision: 10, scale: 2, null: false, default: 0
      t.decimal    :discount, precision: 10, scale: 2, null: false, default: 0
      t.timestamps
    end
  end
end
