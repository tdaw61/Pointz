class LeaguesController < ApplicationController
  #TODO edit league settings page
  #TODO add new user to league needs format, possibly basic edit/new form in css would be helpful
  #TODO show user list option on each league
  #TODO add new user needs to be part of the form. Disable button after submit.
  before_action :set_league, only: [:show, :edit, :update, :destroy, :add_user, :add_user_save, :expand_league_games, :expand_league_users]


  def new
    @league = League.new
  end

  def create
    @league = League.new(league_params)
    # @league.league_users.build({:user_id => current_user.id, :league_id => @league.id})
    if @league.save!
      @league.league_users << LeagueUser.create!(:user_id => current_user.id, :league_id => @league.id, :admin => true)
      redirect_to action: 'show', id: @league.id
    else
      render :new
    end
  end

  def index
    @leagues = current_user.leagues
    @games = @leagues.first.games
    @league_users = @leagues.first.users
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

    redirect_to({:action => 'show', :id => params[:id]})
  end

  def destroy

  end


  def add_user
  end

  def add_user_save
    #TODO add find user by email or username with live search.
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

  end


  private

  def league_params
    params.require(:league).permit(:name)
  end

  def set_league
    @league = League.find(params[:id])
  end
end
