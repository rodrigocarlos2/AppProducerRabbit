class AddNameToCity < ActiveRecord::Migration[5.0]
  def change
    add_column :cities, :name, :string
  end
end
