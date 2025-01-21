class CreateOffers < ActiveRecord::Migration[8.0]
  def change
    create_table :offers do |t|
      t.string :title
      t.text :description
      t.datetime :start_time, default: -> { 'CURRENT_TIMESTAMP' }
      t.datetime :end_time
      t.decimal :discount, precision: 3, scale: 2
      t.references :hotel, null: false, foreign_key: true

      t.timestamps
    end
  end
end
