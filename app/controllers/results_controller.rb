class ResultsController < ApplicationController
  before_action :set_tournament_and_match
  before_action :require_login
  before_action :require_team_captain

  def create
    if @match.active?
      result = @match.results.build(captain: current_user,
                           home_score: params[:result][:home_score], away_score: params[:result][:away_score])

      if result.save
        redirect_to tournament_match_path(@tournament, @match), notice: 'Result has been added'
      else
        redirect_to tournament_match_path(@tournament, @match), flash: { danger: 'Error' }
      end
    else
      redirect_to tournament_match_path(@tournament, @match), flash: { danger: 'Match is not active' }
    end
  end

  private
    def set_tournament_and_match
      @tournament = Tournament.find(params[:tournament_id])
      @match = Match.find(params[:id])
    end

    def require_team_captain
      unless helpers.team_captain?(@match.home) || helpers.team_captain?(@match.away)
        redirect_to @match, flash: { danger: 'You must be captain to add result' }
      end
    end
end
