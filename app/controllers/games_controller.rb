class GamesController < ApplicationController
  #TODO make sure users are logged in to view pages
  #TODO testing suite
  #TODO images and editing for leagues
  #TODO add liking system
  #TODO add comment system
  #TODO pictures still not working
  #TODO add small preview image of picture
  #TODO reformat games table times: start date and end date dont fit on the same line
  #TODO add formatting for username in header bar
  #TODO add verification for point values
  #TODO add a ranking system


  before_action :set_game, only: [:show, :edit, :destroy, :update, :create_event, :end_game, :end_game_save]


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
    @event_votes = Array.new
    @event_votes = @game.active_event_votes(current_user.id)

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
      redirect_to 'show', id: params[:id]
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

  def end_game
    respond_to do |format|
      format.html
      format.js
    end
  end

  def end_game_save
    @game.update_attributes(active: false)
    redirect_to :show, id: @game.id
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
