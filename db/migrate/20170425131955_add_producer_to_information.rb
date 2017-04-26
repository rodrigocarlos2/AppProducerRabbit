class AddProducerToInformation < ActiveRecord::Migration[5.0]
  def change
    add_column :information, :producer, :integer
  end
end
