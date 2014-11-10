class GamesController < ApplicationController
  #TODO make sure users are logged in to view pages
  #TODO testing suite
  #TODO images and editing for leagues

  before_action :set_game, only: [:show, :edit, :destroy, :update, :create_event]


  def new
    league = League.find(params[:league_id])
    @game = league.games.build
  end

  def index
    @games = current_user.games.paginate(page: params[:page])
  end

  def show
    #TODO calculate position of player in game
    #TODO show event history option
    @scores = @game.ordered_scores
    @feed_items = @game.userposts.paginate(page: params[:page], per_page: 15)
    game_events = @game.game_events
    @event_votes = Array.new
    game_events.each do |game_event|
      if !game_event.has_passed?
        @event_votes += game_event.event_votes
      end
    end
    # @event_votes = EventVote.where(game_id: params[:id], user_id: current_user.id)
    @userpost  = current_user.userposts.build

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
        format.json { render :show, status: :created, location: @game}
      else
        format.html { render :new }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    if @game.update(game_params)
      @scores = Score.where(game_id: params[:id])
      render @game
    else
      render edit
    end

  end

  def destroy
    #TODO Modal popover for deleting? - This would be much cooler than the ugly chrome one.

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

    if event_vote.game_event.has_passed?
      Score.update_score event_vote
    end

    redirect_to game_path
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
    params.require(:game).permit(:name, :motto, :start_date, :end_date, :user_id)
  end

  def game_event_params
    params.permit(:point_value, :data)
  end
end
