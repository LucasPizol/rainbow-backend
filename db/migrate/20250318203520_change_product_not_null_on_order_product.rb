class ChangeProductNotNullOnOrderProduct < ActiveRecord::Migration[8.0]
  def change
    change_column_null :order_products, :product_id, true
  end
end
