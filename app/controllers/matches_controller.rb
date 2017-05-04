class MatchesController < ApplicationController
  before_action :set_tournament
  before_action :set_match, except: [:index]
  before_action :require_tournament_admin, only: [:edit, :update, :close]

  def index
  end

  def show
  end

  def edit
  end

  def update
    if !@match.active?
      flash[:danger] = 'Match must be active to change the result'
      redirect_to tournament_match_path(@tournament, @match)
    elsif @match.update(match_params)
      flash.now[:notice] = 'Updated match'
      render :edit
    else
      flash.now[:danger] = 'Error'
      render :edit
    end
  end

  def close
    if @match.status != 'active'
      flash[:danger] = 'Match must be active to close'
      redirect_to tournament_match_path(@tournament, @match)
    elsif @match.close
      flash.now[:notice] = 'Match has been closed'
      if @match.final?
        @tournament.close
      end
      render :edit
    else
      flash[:danger] = 'There must be a winner'
      redirect_to edit_tournament_match_path(@tournament, @match)
    end
  end

  private
    def set_tournament
      @tournament = Tournament.find(params[:tournament_id])
    end

    def set_match
      @match = Match.find(params[:id])
    end

    def match_params
      params.require(:match).permit(:home_score, :away_score)
    end
end
