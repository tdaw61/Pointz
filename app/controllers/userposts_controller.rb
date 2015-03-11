class UserpostsController < ApplicationController
  before_action :signed_in_user, only: [:create, :destroy]

  def create
    # @posts = Post.paginate(page: params[:page], per_page: 15).order('created_at DESC')
    @userpost = current_user.userposts.build(userpost_params)
    @userpost.game_id = params[:game][:id]
    @userpost.post_type = "userpost"
    @game = Game.find(params[:game][:id])
    if params[:picture]

      photo = Photo.new
      photo.picture = params[:picture]
      @userpost.create_photo(picture: params[:picture])

    end


    respond_to do |format|
      if @userpost.save
        @userpost = Userpost.new
        @game_event_feed_items = @game.game_events
        @feed_items = @game.userposts

        format.html { redirect_to request.referer, notice: 'post was successfully created.' }
        format.js
        # format.json { render root_url, status: :created, location: @userpost }
      else
        @game_event_feed_items = @game.game_events
        @feed_items = @game.userposts
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

  def ajax_view_photo
    @userpost = Userpost.find(params[:id])
  end

  private
  def userpost_params
    params.require(:userpost).permit(:data, :picture)
  end
end