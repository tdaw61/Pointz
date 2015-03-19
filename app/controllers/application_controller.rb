class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper

  #TODO BUG - picture on vote form is causing an authenticity token error
  #TODO LAYOUT - redo league layout
  #TODO BUG - figure out how to end game at the set time
  #TODO FEATURE - show list of who voted for what, anonymous voting option
  #TODO FEATURE - live time updates
  #TODO LAYOUT - change any words up top so they arent lost in the background
  #TODO PERF LAYOUT - lightbox needs to clear image or render all at once
  #TODO PERF LAYOUT - find how to render background first, or render images better
  #TODO LAYOUT - change friend box to be below user info, build a search bar into the header of the box. get rid of background color and make image full squares
  #TODO LAYOUT - fix width on columns so resizing to a small screen doesn't look terrible.
  #TODO PERF - images take too long to upload

  #TODO FEATURE - Let admin alter scores for players
  #TODO FEATURE - Starting points for a user when they join the game.

end
