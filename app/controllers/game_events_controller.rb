class GameEventsController < ApplicationController

  def new
    @game_event = GameEvent.new
    @game = Game.find(params[:game_id])
    @users = @game.users
  end

  def create
    @game_event = GameEvent.new(game_event_params)
    if @game_event.save

      #create votes for each user in the game
      @game_event.game.users.each do |user|
        @game_event.event_votes.create_vote_for_game user, params, current_user.id
      end

      if @game_event.has_passed?
        Score.update_score params[:game_id], params[:target_user_id], params[:point_value]
      end

      respond_to do |format|
        @event_votes = EventVote.where(game_id: params[:game_id], user_id: current_user.id)
        @game = Game.find(params[:game_id])
        @game_event = GameEvent.new
        @users = @game.users
        format.html{ redirect_to :controller => :games , :action => :show, :id => params[:game_id] }
        format.js
      end
    else
      render :new
    end
  end

  def show

  end

  def save
    puts "yeah"
  end

  def edit
    puts "yeah"
  end

  def destroy
    puts "yeah"
  end

  def update
    puts "yeah"
  end

  private

  def game_event_params
    params.require(:game_event).permit(:point_value, :data, :target_user_id, :user_id, :game_id)
  end

end
