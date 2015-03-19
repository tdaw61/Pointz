class LeaguesController < ApplicationController
  #TODO FEATURE - add reactivate for games & leagues, might make sense for leagues only

  before_action :set_league, only: [:show, :edit, :update, :destroy, :add_user, :add_user_save, :expand_league_games, :expand_league_users, :remove_user, :remove_user_save, :end_league_save]
  before_action :signed_in_user


  def new
    @league = League.new
  end

  def create
    @league = League.new(league_params)
    if @league.save!
      @league.league_users << LeagueUser.create!(:user_id => current_user.id, :league_id => @league.id, :admin => true)
      redirect_to action: 'show', id: @league.id
    else
      render :new
    end
  end

  def index
    @leagues = current_user.leagues
    if @leagues.empty?
      @games = {}
      @league_users = {}
    else
      @games = @leagues.first.games
      @league_users = @leagues.first.users
    end

  end

  def show
    @league_users = @league.users
    @games = @league.games
    @feed_items = @league.feed_items
    @feed_items = @feed_items.paginate(page: params[:page], per_page: 15)

  end

  def edit
    @league_users = LeagueUser.where(league_id: params[:id])

  end

  def update
    @league_user = LeagueUser.where(user_id: params[:league_user][:admin_id])
    @league.update_attributes(league_params)


      redirect_to({:action => 'show', :id => params[:id]})
  end

  def destroy

  end

  def end_league_save
    @league.update_attribute(:active, false)
    redirect_to({action: 'show', id: @league.id})
  end


  def add_user
  end

  def add_user_save
    #TODO FEATURE - add find user by email or username with live search on friends list.
    #TODO BUG - userpost for user joining league never is seen because feed items are found by game_id
    user = User.find_by email: params[:email]
    if user
      begin
        LeagueUser.create!(league_id: params[:id], user_id: user.id)
      rescue ActiveRecord::RecordNotUnique => e
        flash.alert = user.email + ' is already in the game'
        redirect_to :add_user and return
      end
      begin
        EmailSender.join_league(user, @league, current_user)
      rescue Net::SMTPAuthenticationError, Net::SMTPServerBusy, Net::SMTPSyntaxError, Net::SMTPFatalError, Net::SMTPUnknownError, Net::OpenTimeout => e
        puts e
      end
      Userpost.create({user_id: user.id, post_type: "user_join"})

      redirect_to :action => :show, id: params[:id]
    else
      flash.alert = "The user " + params[:email] + " was not found"
      redirect_to :add_user
    end

  end

  def expand_league_games
    @games = @league.games
  end

  def expand_league_users
    @league_users = @league.users
  end

  def remove_user
    @users = @league.users
    respond_to do |format|
      format.html
      format.js
    end
  end

  def remove_user_save
    #TODO decide if user should stay in games or be removed from all games too.
    user = User.find(params[:target_user_id][:target_user_id])
    @league.users.delete(user)
    # @league.games.scores.delete(user)
    redirect_to action: 'show', id: @league.id
  end


  private

  def league_params
    params.require(:league).permit(:name, :picture)
  end

  def set_league
    @league = League.find(params[:id])
  end
end
