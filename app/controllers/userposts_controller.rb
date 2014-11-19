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
        @feed_items = @feed_items.paginate(page: params[:page], per_page: 15)

        format.html { redirect_to request.referer, notice: 'post was successfully created.' }
        format.js
        # format.json { render root_url, status: :created, location: @userpost }
      else
        @user_feed_items = @game.userposts
        @game_event_feed_items = @game.game_events
        @feed_items = (@user_feed_items + @game_event_feed_items).sort_by(&:created_at).reverse
        format.html { redirect_to :back  }
        format.json { render json: @user.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  def destroy
    @userpost = Userpost.find(params[:id])
    respond_to do |format|
      if @userpost.destroy!
        format.html { redirect_to :back, notice: 'post deleted' }
        # format.json {render root_url, status: :deleted, location: }
      else
        render user.root_url
      end
    end
  end

  def paginate
    if params[:id].nil?
      @feed_items = current_user.userposts.paginate(page: params[:page])
    else
      @game = Game.find(params[:id])
      @feed_items = @game.userposts.paginate(page: params[:page], per_page: 15)

    end
    respond_to do |format|
      format.js {render 'userposts/paginate'}
    end
  end

  def show

  end

  private
  def userpost_params
    params.require(:userpost).permit(:data, :picture)
    # params.require(:game).permit(:id)
  end
end