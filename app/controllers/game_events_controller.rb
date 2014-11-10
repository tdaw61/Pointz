class GameEventsController < ApplicationController

  def new
    @game_event = GameEvent.new
    @game = Game.find(params[:game_id])
    @users = @game.users
  end

  def create

    #TODO refactor the create event. Move logic into model & correctly ajax back response.
    @game_event = GameEvent.new(game_event_params)
    # @game_event.init_votes
    if @game_event.save

      #create votes for each user in the game
      @game_event.game.users.each do |user|
        @game_event.event_votes.create_vote_for_game user, params, current_user.id
      end

      if @game_event.has_passed?
        Score.update_score @game_event
      end

      @game_event.create_userpost

      respond_to do |format|
        @event_votes = EventVote.where(game_id: params[:game_id], user_id: current_user.id)
        @game = Game.find(params[:game_id])
        @game_event = GameEvent.new
        @scores = @game.scores
        @users = @game.users
        @feed_items = @game.userposts.paginate(page: params[:page], per_page: 15)

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
