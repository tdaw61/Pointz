class GameEventsController < ApplicationController

  def new
    @game_event = GameEvent.new
    @game = Game.find(params[:game_id])
  end

  def create
    @game_event = GameEvent.new(game_event_params)
    if @game_event.save

      #create votes for each user in the game
      @users = @game_event.game.users

      @users.each do |user|
        event_vote = @game_event.event_votes.create_vote_for_game user, params, current_user.id
        event_vote.save
      end

      redirect_to :controller => :games , :action => :show, :id => params[:game_id]
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
