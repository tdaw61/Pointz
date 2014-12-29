class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :data, null: false
      t.integer :user_id, null: false
      t.integer :userpost_id, null: false
      t.string :picture

      t.timestamps
    end
  end
end
