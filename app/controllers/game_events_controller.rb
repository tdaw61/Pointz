class GameEventsController < ApplicationController
  before_action :signed_in_user

  def new
    @game_event = GameEvent.new
    @game = Game.find(params[:game_id])
    @users = @game.users
  end

  def create
    @game_event = GameEvent.new(game_event_params)
    @game = Game.find(params[:game_id])
    @users = @game.users

    if @game_event.save
      @game_event.init_votes params, current_user.id

      respond_to do |format|
        @event_votes = @game.active_event_votes(current_user.id)
        @game_event = GameEvent.new
        @scores = @game.ordered_scores
        @feed_items = @game.userposts.paginate(page: params[:page], per_page: 15)

        format.html{ redirect_to :controller => :games , :action => :show, :id => params[:game_id] }
        format.js
      end
    else
    end
  end

  def show

  end

  def save
  end

  def edit
  end

  def destroy
  end

  def update
  end


  private

  def game_event_params
    params.require(:game_event).permit(:point_value, :data, :target_user_id, :user_id, :game_id)
  end

end
