class CreateTrainingProducts < ActiveRecord::Migration
  def change
    create_table :training_products do |t|
      t.integer :training_id
      t.integer :product_id

      t.timestamps
    end
    add_index :training_products, :training_id
    add_index :training_products, :product_id
    add_index :training_products, [:training_id, :product_id], unique: true
  end
end
