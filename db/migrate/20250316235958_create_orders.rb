class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.references :customer, null: false, foreign_key: true
      t.integer :total, null: false
      t.integer :status, null: false

      t.timestamps
    end
  end
end
