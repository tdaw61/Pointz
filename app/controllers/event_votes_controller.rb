class EventVotesController < ApplicationController
  before_action :signed_in_user

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


  def expand_vote_detail
    @game_event = GameEvent.find(params[:game_event_id])
    @event_vote = EventVote.find(params[:event_vote_id])
    respond_to do |format|
      format.js {render 'games/expand_vote_detail'}
    end
  end

end
