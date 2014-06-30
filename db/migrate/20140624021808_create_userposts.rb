class CreateUserposts < ActiveRecord::Migration
  def change
    create_table :userposts do |t|
      t.string :data
      t.integer :user_id
      t.integer :game_id

      t.timestamps
    end
    add_index :userposts, [:user_id, :created_at]

  end
end
