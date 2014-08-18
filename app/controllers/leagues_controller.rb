class LeaguesController < ApplicationController
    before_action :set_league, only: [:show, :edit, :destroy ]



    def new
    @league = League.new
  end

  def create
    @league = League.new(league_params)
    # @league.league_users.build({:user_id => current_user.id, :league_id => @league.id})
    if @league.save!
      @league.league_users << LeagueUser.new(:user_id => current_user.id, :league_id => @league.id)
      redirect_to action: 'show', id: @league.id
    else
      render :new
    end
  end

  def index
    @leagues = current_user.leagues
  end

  def show
    @league_users = @league.users

  end

    def edit

    end

    def destroy

    end






  private

   def league_params
     params.require(:league).permit(:name)
   end

   def set_league
     @league = League.find(params[:id])
   end
end
