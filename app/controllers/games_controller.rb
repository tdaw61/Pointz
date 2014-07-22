class GamesController < ApplicationController
  before_action :set_game, only: [:show, :edit, :destroy, :update, :add_user, :add_user_save, :create_event, :save_event]


  def new
    @game = Game.new
  end

  def index
    @games = Game.paginate(page: params[:page])
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
        render add_user_url
      end
    end

  end

  def show
    # @gameUserPoints = Score.find_by_game_id(params[:id])
    # @gameUserPoints.find :game_id
    @scores = Score.where(game_id: params[:id])
    @user_feed_items = Userpost.where(game_id: params[:id])
    @game_event_feed_items = GameEvent.where(game_id: params[:id])
    @feed_items = (@user_feed_items + @game_event_feed_items).sort_by(&:created_at)
    @game_votes = EventVote.where(game_id: params[:id], user_id: current_user.id, has_voted: false)
    @userpost  = current_user.userposts.build

  end

  #When the user wants to change the point value of another player
  def create_event
    @gameEvent = GameEvent.new
  end

  #saving new user event
  def save_event
    @gameEvent = GameEvent.new(game_event_params)
    @gameEvent.game_id = params[:id]
    @gameEvent.user_id = params[:user_id]
    if @gameEvent.save

      #create votes for each user in the game
      @users = Game.find(params[:id]).users
      @users.each do |user|
        eventVote = EventVote.new
        eventVote.game_event_id = @gameEvent.id
        eventVote.user_id = user.id
        eventVote.game_id = params[:id]
        eventVote.has_voted = false
        eventVote.user_point_value = params[:point_value]
        eventVote.save
      end
      #for now just straight update the points for the user
      score = Score.where(game_id: params[:id], user_id: params[:user_id]).first

      #refactor this into score
      score.points += params[:point_value].to_i

      score.save

      @scores = Score.where(game_id: params[:id])
      # render :show
      redirect_to :action => :show, :id => params[:id]
    else
      render :create_event
    end
  end

  def edit

  end

  def create
    @game = Game.new(game_params)

    respond_to do |format|
      if @game.save
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
      render 'games/show'
    else
      render edit
    end

  end

  def destroy
    if(@game.destroy)
      @games = Game.paginate(page: params[:page])
      render 'games/index'
    else
      render 'games/show'
    end

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
