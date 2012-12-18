class CreateEventTypeTrainings < ActiveRecord::Migration
  def change
    create_table :event_type_trainings do |t|
      t.integer :event_type_id
      t.integer :training_id

      t.timestamps
    end
    add_index :event_type_trainings, :event_type_id
    add_index :event_type_trainings, :training_id
    add_index :event_type_trainings, [:event_type_id, :training_id], unique: true
  end
end
