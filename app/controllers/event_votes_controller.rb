class EventVotesController < ApplicationController

  def show_events_history
    @game = Game.find(params[:id])
    if params[:on_off] == "1"
      @event_votes = @game.inactive_event_votes current_user.id
    else
      @event_votes = @game.active_event_votes current_user.id
    end
    respond_to do |format|
      format.js {render 'games/show_events_history'}
    end
  end

end
