class CreateCartItem < ActiveRecord::Migration[8.0]
  def change
    create_table :cart_items do |t|
      t.references :product, null: false, foreign_key: true
      t.references :client, null: false, foreign_key: true

      t.integer :quantity, default: 1

      t.timestamps
    end
  end
end
