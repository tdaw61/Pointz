class LeaguesController < ApplicationController
    before_action :set_league, only: [:show, :edit, :destroy ]



    def new
    @league = League.new
  end

  def create
    @league = League.new(league_params)
    if @league.save!
      render @league
    else
      render :new
    end
  end

  def index
    @leagues = current_user.leagues
  end

  def show

  end

    def edit

    end

    def destroy

    end






  private

   def league_params
     params.require(:league).permit(:name)
   end

   def set_league
     @league = League.find(params[:id])
   end
end
