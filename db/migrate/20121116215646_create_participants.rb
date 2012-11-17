class CreateParticipants < ActiveRecord::Migration
  def change
    create_table :participants do |t|
      t.string :name
      t.string :email

      t.timestamps
    end
    add_index :participants, :email, unique: true
    add_index :participants, :name
  end
end
