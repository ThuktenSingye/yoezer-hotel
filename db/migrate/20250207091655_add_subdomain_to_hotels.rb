class AddSubdomainToHotels < ActiveRecord::Migration[8.0]
  def change
    add_column :hotels, :subdomain, :string
    add_index :hotels, :subdomain, unique: true
  end
end
