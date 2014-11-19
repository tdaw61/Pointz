class GameEventsController < ApplicationController

  def new
    @game_event = GameEvent.new
    @game = Game.find(params[:game_id])
    @users = @game.users
  end

  def create
    #TODO vote saving with no data causes error that doesn't do anything

    #TODO refactor the create event. Move logic into model & correctly ajax back response.
    @game_event = GameEvent.new(game_event_params)

    if @game_event.save
      @game_event.init_votes params, current_user.id

      respond_to do |format|
        @game = Game.find(params[:game_id])

        @event_votes = @game.active_event_votes(current_user.id)
        # game_events = @game.game_events
        # @event_votes = Array.new
        # game_events.each do |game_event|
        #   if !game_event.has_passed?
        #     @event_votes += game_event.event_votes
        #   end
        # end
        @game_event = GameEvent.new
        @scores = @game.scores
        @users = @game.users
        @feed_items = @game.userposts.paginate(page: params[:page], per_page: 15)

        format.html{ redirect_to :controller => :games , :action => :show, :id => params[:game_id] }
        format.js
      end
    else
      flash.alert = "You must enter a reason"
      redirect_to :controller => :games , :action => :show, :id => params[:game_id]
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
