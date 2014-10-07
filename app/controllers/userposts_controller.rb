class UserpostsController < ApplicationController
  before_action :signed_in_user, only: [:create, :destroy]

  def create
    # @posts = Post.paginate(page: params[:page], per_page: 15).order('created_at DESC')
    @userpost = current_user.userposts.build(userpost_params)
    @userpost.game_id = params[:game][:id]
    @game = Game.find(params[:game][:id])

    respond_to do |format|
      if @userpost.save
        @userpost = Userpost.new
        @user_feed_items = @game.userposts
        @game_event_feed_items = @game.game_events
        @feed_items = (@user_feed_items + @game_event_feed_items).sort_by(&:created_at).reverse
        @feed_items.paginate(page: params[:page], per_page: 15)

        format.html { redirect_to request.referer, notice: 'post was successfully created.' }
        format.js
        # format.json { render root_url, status: :created, location: @userpost }
      else
        @user_feed_items = @game.userposts
        @game_event_feed_items = @game.game_events
        @feed_items = (@user_feed_items + @game_event_feed_items).sort_by(&:created_at).reverse
        format.html { render :back }
        format.json { render json: @user.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  def destroy
    @userpost = Userpost.find(params[:id])
    respond_to do |format|
      if @userpost.destroy!
        format.html { redirect_to root_url, notice: 'post deletedgae' }
        # format.json {render root_url, status: :deleted, location: }
      else
        render user.root_url
      end
    end
  end

  private
  def userpost_params
    params.require(:userpost).permit(:data)
    # params.require(:game).permit(:id)
  end
end