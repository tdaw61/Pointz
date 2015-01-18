class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper


  #TODO updating the vote to pass maybe create a new feed item?
  #TODO explain score cap on create game, tutorial on the page maybe?
  #TODO make vote into modal popup, expand reason for vote into a text area with picture
  #TODO move to two column layout, put end game in game settings and move game settings to a link
  #TODO league and game layout are too similar, need to be able to tell them apart
end
