class AddProfileReferencesToEmployee < ActiveRecord::Migration[8.0]
  def change
    add_reference :employees, :profile, foreign_key: true
  end
end
