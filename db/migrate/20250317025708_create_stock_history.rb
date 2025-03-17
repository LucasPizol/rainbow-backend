class CreateStockHistory < ActiveRecord::Migration[8.0]
  def change
    create_table :stock_histories do |t|
      t.references :product, null: false, foreign_key: true
      t.integer :quantity, null: false
      t.decimal :price, precision: 10, scale: 2, null: false
      t.integer :operation, null: false
      t.string :description

      t.timestamps
    end
  end
end
