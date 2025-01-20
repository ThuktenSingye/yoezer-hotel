class CreateFeedbacks < ActiveRecord::Migration[8.0]
  def change
    create_table :feedbacks do |t|
      t.string :name
      t.string :email
      t.text :feedback
      t.references :hotel, null: false, foreign_key: true

      t.timestamps
    end
  end
end
