class EventVotesController < ApplicationController

  def show_events_history
    @game = Game.find(params[:id])
    @event_votes = Array.new
        @game.game_events.each do |game_event|
          @event_votes += game_event.event_votes
        end
    respond_to do |format|
      format.js {render 'games/show_events_history'}
    end
  end

end
