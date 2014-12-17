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


  #TODO expand vote detail could be renedered but just hidden at the beginning? or make the call ajax. 
  def expand_vote_detail
    respond_to do |format|
      format.js {render 'games/expand_vote_detail'}
    end
  end

end
