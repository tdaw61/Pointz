class UserpostsController < ApplicationController
  before_action :signed_in_user, only: [:create, :destroy]

  def create
    @userpost = current_user.userposts.build(userpost_params)
    respond_to do |format|
      if @userpost.save
        format.html { redirect_to root_url, notice: 'post was successfully created.' }
        # format.json { render root_url, status: :created, location: @userpost }
      else
        format.html { render root_url }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @userpost = Userpost.find(params[:id])
    respond_to do |format|
      if @userpost.destroy!
        format.html { redirect_to root_url, notice: 'post deleted' }
        # format.json {render root_url, status: :deleted, location: }
      else
        render user.root_url
      end
    end
  end

  private
  def userpost_params
    params.require(:userpost).permit(:data)
  end
end