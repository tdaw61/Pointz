class UserpostController < ApplicationController
  before_action :signed_in_user, only: [:create, :destroy]

  def create
    @userpost = current_user.userposts.build(userpost_params)
  end

  def destroy

  end

  private
  def userpost_params
    params.require(:userpost).permit(:data)
  end
end