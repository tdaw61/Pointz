class AddPictureToGameEvent < ActiveRecord::Migration
  def change
    add_column :game_events, :picture, :string
  end
end
