class CreateAddress < ActiveRecord::Migration[8.0]
  def change
    create_table :addresses do |t|
      t.references :client, null: false, foreign_key: true
      t.string  :street, null: false
      t.string  :number, null: false
      t.string  :complement
      t.string  :neighborhood, null: false
      t.string  :city, null: false
      t.string  :state, null: false
      t.string  :zip_code, null: false
      t.string  :reference

      t.string  :name, null: false

      t.boolean :is_default, null: false, default: false
      t.boolean :is_invoicing_address, null: false, default: false

      t.timestamps
    end
  end
end
