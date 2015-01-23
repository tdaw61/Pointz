class GamesController < ApplicationController
  before_action :signed_in_user
  #TODO add categories for type of manpoint - then can do a stat breakdown per player
  #TODO Add setting for event vote time limit before expiration.
  #TODO Calendar symbol in create game needs to link.


  #TODO deal with permission problems. Show games/leagues unless private - need to add a private feature.
  #TODO in addition to permissions, make sure users can't post to closed games/leagues. Add a before filter
  #TODO testing suite


  before_action :set_game, only: [:show, :edit, :destroy, :update, :create_event, :end_game, :end_game_save, :game_settings, :ajax_userpost_form, :ajax_vote_form]


  def new
    league = League.find(params[:league_id])
    @game = league.games.build
  end

  def index
    @games = current_user.games.paginate(page: params[:page])
  end

  #TODO there are multiple n+1 issues here
  def show
    @scores = @game.ordered_scores
    @game = Game.includes(:userposts, :users, {userposts: [:comments] }).where(id: @game.id)
    @game = @game[0]
    @feed_items = @game.userposts.paginate(page: params[:page], per_page: 15)
    @event_votes = Array.new
    @event_votes = @game.active_event_votes(current_user.id)
    @comment = Comment.new
    @game_event = @game.game_events.build
    @users = @game.users
    respond_to do |format|
      format.js
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
      @scores = Score.where(game_id: params[:id])
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
