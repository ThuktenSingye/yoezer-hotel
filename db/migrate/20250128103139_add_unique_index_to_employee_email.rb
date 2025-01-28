class AddUniqueIndexToEmployeeEmail < ActiveRecord::Migration[8.0]
  def change
    add_index :employees, :email, unique: true
  end
end
