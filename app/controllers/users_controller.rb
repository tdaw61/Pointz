class UsersController < ApplicationController

  #TODO add in cancel buttons everywhere, often times you are stuck on a form.
  #TODO search is going to be way too simple at first
  #TODO add filtering option for feed to do only events or only userposts.
  #TODO add picture to event vote form

  before_action :set_user, only: [:show, :destroy]
  before_action :signed_in_user, only: [:edit, :index, :update]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user,     only: :destroy


  # GET /users
  # GET /users.json
  def index
    if current_user.super_user?
      @users = User.paginate(page: params[:page])
    else
      render '/public/404'
    end
  end

  def home
    if signed_in?
      @userpost  = current_user.userposts.build
      @user = User.includes(:userposts, {userposts: [:comments, :likes]}, :leagues, {leagues: [:games]}, :friends, :requested_friends ).where(id: current_user.id).first
      @feed_items = @user.userposts
      @leagues = current_user.leagues
      @user = current_user
      @comment = Comment.new
      @user_friends = current_user.friends
      @friend_requests = current_user.requested_friends
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @userposts = @user.userposts.paginate(page: params[:page])
    @games = @user.games
    @feed_items = @user.userposts.paginate(page: params[:page])
    @leagues = @user.leagues
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        sign_in @user
        begin
        EmailSender.welcome(@user)
        rescue  EOFError,IOError,TimeoutError,Errno::ECONNRESET,Errno::ECONNABORTED,Errno::EPIPE, Errno::ETIMEDOUT, Net::SMTPAuthenticationError, Net::SMTPServerBusy, Net::SMTPSyntaxError, Net::SMTPUnknownError, OpenSSL::SSL::SSLError => e
          #ignore and move on
        end
        format.html { redirect_to root_path, user_id: @user.id }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update



    respond_to do |format|
      if @user.update_attributes(user_params)
        if params[:picture]
          Photo.update_photo(@user, params[:picture])
        end
        flash[:success] = "Profile updated"
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end


  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url}
      format.json { head :no_content }
    end
  end

  def search
    search_condition = "%" + params['srch-term'] + "%"
    @search_users = User.where('name LIKE ? OR email LIKE ? and id not in (?)', search_condition, search_condition, current_user.id)

    #need to load up the current users friends or else the queries are endless
    current_user_friends_loaded = User.includes(:pending_friends, :friends, :requested_friends).find(current_user.id)
    @current_user = current_user_friends_loaded
    @users = @search_users.paginate(page: params[:page])
  end

  def crop
    @user = User.find(params[:id])
    @picture = @user.photo.picture
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :photo, photo_attributes: [:picture])
  end


  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end
