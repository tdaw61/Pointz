class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.string :name
      t.string :picture
      t.integer :picture_id
      t.string :picture_type

      t.timestamps
    end
  end
end
