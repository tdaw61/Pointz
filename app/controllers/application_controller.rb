class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper

  #TODO picture on vote form is causing an authenticity token error
  #TODO redo league layout
  #TODO figure out how to end game at the set time
  #TODO show list of who voted for what, anonymous voting option
  #TODO live time updates
  #TODO pictures could be made polymorphic
  #TODO redo dates to make it all mm/dd/yyyy - game settings have that problem

end
