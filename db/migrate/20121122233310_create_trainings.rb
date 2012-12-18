class CreateTrainings < ActiveRecord::Migration
  def change
    create_table :trainings do |t|
      t.string   :name
      t.string   :city
      t.text     :introduction
      t.text     :description
      t.integer  :price_per_person, :precision => 8, :scale => 2
      t.datetime :start_time
      t.integer  :number_of_days
      t.integer  :number_of_hours
      t.boolean  :exemplary, default: false  

      t.timestamps
    end
    add_index :trainings, :name
    add_index :trainings, :start_time
    add_index :trainings, :city
  end
end
