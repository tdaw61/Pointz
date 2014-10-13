class GamesController < ApplicationController
  before_action :set_game, only: [:show, :edit, :destroy, :update, :create_event]


  def new
    league = League.find(params[:league_id])
    @game = league.games.build
  end

  def index
    @games = current_user.games.paginate(page: params[:page])
  end

  def show
    @scores = @game.ordered_scores
    @user_feed_items = @game.userposts
    # @game_event_feed_items = @game.game_events
    # @feed_items = (@user_feed_items + @game_event_feed_items).sort_by(&:created_at).reverse
    @feed_items = @user_feed_items.paginate(page: params[:page], per_page: 15)
    @event_votes = EventVote.where(game_id: params[:id], user_id: current_user.id)
    @userpost  = current_user.userposts.build

    #TODO move this to ajax call and expand on game_event creation
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
      Score.update_score event_vote.game_id, event_vote.user_id, event_vote.game_event.point_value
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
