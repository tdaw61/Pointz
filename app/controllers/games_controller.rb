class GamesController < ApplicationController
  before_action :signed_in_user
  #TODO FEATURE - add categories for type of point - then can do a stat breakdown per player
  #TODO FEATURE - Add setting for event vote time limit before expiration.
  #TODO deal with permission problems. Show games/leagues unless private - need to add a private feature.
  #TODO in addition to permissions, make sure users can't post to closed games/leagues. Add a before filter
  #TODO testing suite


  before_action :set_game, only: [ :edit, :destroy, :update, :create_event, :end_game, :end_game_save, :game_settings, :ajax_userpost_form, :ajax_vote_form]


  def new
    league = League.find(params[:league_id])
    @game = league.games.build
  end

  def index
    @games = current_user.games.paginate(page: params[:page])
  end

  #TODO REFACTOR - count queries still need to be eager loaded.
  def show
    @game = Game.includes(:userposts, {userposts: [:comments, {comments: [:likes]}, :likes]}, :users , :active_game_events, :scores ).where(id: params[:id]).first
    @game.active_game_events.includes(:event_votes).where(user_id: current_user.id)
    @feed_items = @game.userposts.paginate(page: params[:page], per_page: 10)
    @event_votes = Array.new
    @game.active_game_events.each do |game_event|
      @event_votes += game_event.event_votes
    end
    @comment = Comment.new
    @game_event = @game.game_events.build
    respond_to do |format|
      format.js {render 'userposts/paginate'}
      format.html
    end


  end

  def edit

  end

  def create
    league = League.find(params[:league_id])
    @game = league.games.new(game_params)

    respond_to do |format|
      if @game.save
        league.users.each do |user|
          @game.scores.create!({:user_id => user.id, :game_id => @game.id})
        end

        format.html { redirect_to @game}
        # format.json { render :show, status: :created, location: @game}
      else
        format.html { render :new }
        # format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    if @game.update(game_params)
      DateTime.strptime(params[:game][:end_date], '%m/%d/%y')
      redirect_to 'show', id: params[:id]
    else
      render edit
    end

  end

  def destroy

    if @game.destroy
      @games = Game.paginate(page: params[:page])
      render games_path
    else
      render @game
    end

  end


  def save_vote
    event_vote = EventVote.find(params[:event_vote_id])
    event_vote.cast_vote params[:vote].to_i

    redirect_to game_path
  end

  def end_game
    respond_to do |format|
      format.html
      format.js
    end
  end


  def end_game_save
    @game.update_attribute(:active, false)
    redirect_to({action: 'show', id: @game.id})
  end

  def game_settings
    render 'game_settings'
  end

  def ajax_userpost_form

  end

  def ajax_vote_form
    @users = @game.users
    @game_event = GameEvent.new
  end

  #When the user wants to change the point value of another player
  def create_event
    @game_event = GameEvent.new
  end


  private

  def set_game
    @game = Game.find(params[:id])
  end

  def game_params
    params.require(:game).permit(:name, :motto, :start_date, :end_date, :user_id, :score_cap, :point_tiers)
  end

  def game_event_params
    params.permit(:point_value, :data)
  end
end
