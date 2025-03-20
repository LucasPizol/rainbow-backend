class ChangeOrderProductsDiscountColumnToDecimal < ActiveRecord::Migration[8.0]
  def change
    change_column :order_products, :discount, :decimal, precision: 10, scale: 2
  end
end
