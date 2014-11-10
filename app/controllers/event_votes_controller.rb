class EventVotesController < ApplicationController

  def show_events_history
    respond_to do |format|
      format.js {render 'userposts/paginate'}
    end
  end

end
