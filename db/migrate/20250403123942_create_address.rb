class CreateAddress < ActiveRecord::Migration[8.0]
  def change
    create_table :addresses do |t|
      t.references :client, null: false, foreign_key: true
      t.string :street, null: false
      t.string :number, null: false
      t.string :complement
      t.string :neighborhood, null: false
      t.string :city, null: false
      t.string :state, null: false
      t.string :zip_code, null: false
      t.string :reference

      t.boolean :is_default, default: false
      t.boolean :is_invoicing_address, default: false

      t.timestamps
    end
  end
end
