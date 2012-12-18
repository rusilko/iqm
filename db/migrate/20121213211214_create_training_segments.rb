class CreateTrainingSegments < ActiveRecord::Migration
  def change
    create_table  :training_segments do |t|
      t.integer   :segment_id
      t.integer   :training_id
      t.string    :name
      t.text      :scenario
      t.integer   :number_of_hours
      t.datetime  :start_time
      t.integer   :lineup

      t.timestamps
    end
    add_index :training_segments, :segment_id
    add_index :training_segments, :training_id
    add_index :training_segments, [:segment_id, :training_id], unique: true
  end
end
