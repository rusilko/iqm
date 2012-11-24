class CreateTrainings < ActiveRecord::Migration
  def change
    create_table :trainings do |t|
      t.string :name
      t.date :start_date
      t.date :end_date
      t.string :city
      t.integer :price_per_person, :precision => 8, :scale => 2
      t.integer :training_type_id

      t.timestamps
    end
    add_index :trainings, :name
    add_index :trainings, :start_date
    add_index :trainings, :city
    add_index :trainings, :training_type_id
  end
end
