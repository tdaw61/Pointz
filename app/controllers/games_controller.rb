class GamesController < ApplicationController
  before_action :set_game, only: [:show, :edit, :destroy, :update, :add_user, :add_user_save, :create_event, :save_event]


  def new
    @game = Game.new
  end

  def index
    @games = current_user.games.paginate(page: params[:page])
  end

  def show
    @scores = @game.scores
    @user_feed_items = @game.userposts
    @game_event_feed_items = @game.game_events
    @feed_items = (@user_feed_items + @game_event_feed_items).sort_by(&:created_at)
    @event_votes = EventVote.where(game_id: params[:id], user_id: current_user.id)
    @userpost  = current_user.userposts.build

  end

  def edit

  end

  def create
    @game = Game.new(game_params)

    respond_to do |format|
      if @game.save
        @game.scores.create!({:user_id => current_user.id, :game_id => @game.id})

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
    if(@game.destroy)
      @games = Game.paginate(page: params[:page])
      render games_path
    else
      render @game
    end

  end


  def save_vote
    event_vote = EventVote.find(params[:event_vote_id])
    event_vote.cast_vote params

    if event_vote.game_event.has_passed?
      score = Score.where(game_id: params[:id], user_id: event_vote.target_user_id).first

      #TODO
      #set up for users to vote with a new point value, keep value and average and maybe throw out outliers.
      # score.points += params[:point_value].to_i

      score.points += event_vote.game_event.point_value

      score.save
    end
    event_vote.save


    redirect_to game_path
  end

  #saving new user event
  def save_event
    @game_event = GameEvent.new(game_event_params)
    @game_event.target_user_id = params[:user_id]
    @game_event.game_id = params[:id]
    @game_event.user_id = current_user.id
    @game_event.yes_votes = 1
    if @game_event.save


      #create votes for each user in the game
      @users = Game.find(params[:id]).users.to_a

      @users.each do |user|
        event_vote = EventVote.new

        event_vote.target_user_id = params[:user_id]
        event_vote.game_event_id = @game_event.id
        event_vote.user_id = user.id
        event_vote.game_id = params[:id]
        if(user.id == current_user.id)
          event_vote.vote = 1
          event_vote.has_voted = true
        else
          event_vote.has_voted = false
        end
        event_vote.user_point_value = params[:point_value]
        event_vote.save
      end
      #for now just straight update the points for the user


      @scores = Score.where(game_id: params[:id])

      # render :show
      redirect_to :action => :show, :id => params[:id]
    else
      render :create_event
    end
  end

  def add_user
  end

  def add_user_save
    user = User.find(params[:user_id])
    if(user)
      scores = Score.new
      scores.game_id = params[:id]
      scores.user_id = params[:user_id]
      scores.points = 0
      if scores.save!
        @scores = Score.where(game_id: params[:id], user_id: params[:user_id])
        redirect_to @game
      else
        render add_user_path
      end
    end

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
