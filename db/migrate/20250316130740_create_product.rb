class CreateProduct < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.text :description
      t.decimal :price, precision: 10, scale: 2, null: false
      t.integer :stock, null: false
      t.string :sku, null: false, index: { unique: true }
      t.string :status, null: false
      t.references :category, null: false, foreign_key: true
      t.references :subcategory, foreign_key: true
      t.integer :minimum_stock

      t.timestamps
    end
  end
end
