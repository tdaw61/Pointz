class AddAdminToLeagueUsers < ActiveRecord::Migration
  def change
    add_column :league_users, :admin, :boolean, :default => false
  end
end
