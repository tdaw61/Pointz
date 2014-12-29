class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes do |t|
      t.integer :post_id
      t.boolean :like, null: false

      t.timestamps
    end
  end
end
