class LeaguesController < ApplicationController
  #TODO edit league settings page
  #TODO add new user to league needs format, possibly basic edit/new form in css would be helpful
  before_action :set_league, only: [:show, :edit, :destroy, :add_user, :add_user_save]


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
  end

  def show
    @league_users = @league.users
    @games = @league.games
    @feed_items = @league.feed_items
    @feed_items = @feed_items.paginate(page: params[:page], per_page: 15)

  end

  def edit

  end

  def destroy

  end


  def add_user
  end

  def add_user_save

    #REFACTOR THIS PLEASE
    user = User.find_by email: params[:email]
    if (user)
      begin
        LeagueUser.create!(league_id: params[:id], user_id: user.id)
      rescue ActiveRecord::RecordNotUnique => e
        flash.alert = user.email + ' is already in the game'
        redirect_to :add_user and return
      end
      begin
        EmailSender.join_league(user, @league, current_user)
      rescue Net::SMTPAuthenticationError, Net::SMTPServerBusy, Net::SMTPSyntaxError, Net::SMTPFatalError, Net::SMTPUnknownError => e
        puts "email error"
      end
      Userpost.create({user_id: user.id, type: "user_join"})

      redirect_to :action => :show, id: params[:id]
    else
      flash.alert = "not a valid user"
      redirect_to :add_user
    end

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
