class CreateAddresses < ActiveRecord::Migration[8.0]
  def change
    create_table :addresses do |t|
      t.string :dzongkhag
      t.string :gewog
      t.text :street_address
      t.integer :address_type, default: 0, null: false
      t.references :addressable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
