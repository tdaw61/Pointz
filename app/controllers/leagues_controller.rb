class LeaguesController < ApplicationController
  before_action :set_league, only: [:show, :edit, :destroy, :add_user]


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
    @games = @league.games

  end

  def edit

  end

  def destroy

  end


  def add_user
  end

  def add_user_save
    user = User.find_by email: params[:email]

    if (user)
      begin
        LeagueUser.create!(league_id: params[:id], user_id: user.id)
      rescue ActiveRecord::RecordNotUnique => e
        flash.alert = user.email + ' is already in the game'
        redirect_to :add_user and return
      end
      redirect_to :action => :show, id: params[:id]
    else
      flash.alert = "not a valid user"
      redirect_to :add_user
    end
  end


  private

  def league_params
    params.require(:league).permit(:name)
  end

  def set_league
    @league = League.find(params[:id])
  end
end
