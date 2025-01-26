class CreateBedTypes < ActiveRecord::Migration[8.0]
  def change
    create_table :bed_types do |t|
      t.string :name

      t.timestamps
    end
    add_index :bed_types, :name, unique: true
  end
end
