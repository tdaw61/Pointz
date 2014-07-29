class AddTargetUserIdEventVotes < ActiveRecord::Migration
  def change

    add_column :event_votes, :target_user_id, :integer

  end
end
