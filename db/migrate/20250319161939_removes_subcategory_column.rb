class RemovesSubcategoryColumn < ActiveRecord::Migration[8.0]
  def change
    remove_column :products, :subcategory_id
  end
end
