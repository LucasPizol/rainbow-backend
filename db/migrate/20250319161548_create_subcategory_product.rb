class CreateSubcategoryProduct < ActiveRecord::Migration[8.0]
  def change
    create_table :subcategory_products do |t|
      t.references :subcategory, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.timestamps
    end
  end
end
