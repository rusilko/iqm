class CreateEventParticipations < ActiveRecord::Migration
  def change
    create_table :event_participations do |t|
      t.integer :event_id
      t.integer :participant_id

      t.timestamps
    end
    add_index :event_participations, :event_id
    add_index :event_participations, :participant_id
    add_index :event_participations, [:event_id, :participant_id], unique: true
  end
end
