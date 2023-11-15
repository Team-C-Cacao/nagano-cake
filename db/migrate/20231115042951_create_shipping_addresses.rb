class CreateShippingAddresses < ActiveRecord::Migration[6.1]
  def change
    create_table :shipping_addresses do |t|
      t.integer :customer_id
      t.string :name, null: false
      t.string :shipping_addresses, null: false
      t.string :postal_code, null: false

      t.timestamps
    end
  end
end
