class CreateLeagueUsers < ActiveRecord::Migration
  def change
    create_table :league_users do |t|

      t.integer :user_id, :null => false
      t.integer :league_id, :null => false

      t.timestamps
    end

    add_index :league_users, :user_id
    add_index :league_users, :league_id
    add_index :league_users, [:user_id, :league_id], unique: true
  end
end
