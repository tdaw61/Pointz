class CreateEventVotes < ActiveRecord::Migration
  def change
    create_table :event_votes do |t|
      t.integer :game_id
      t.integer :user_id
      t.boolean :vote
      t.integer :user_point_value
      t.integer :event_id
      t.boolean :has_voted
      t.belongs_to :game
      t.belongs_to :user
      t.belongs_to :game_event

      t.timestamps
    end
  end
end
