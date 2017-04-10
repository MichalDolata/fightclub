class TournamentsController < ApplicationController
  before_action :set_tournament, except: [:index, :new, :create]
  before_action :require_login, except: [:index, :show]
  before_action :require_tournament_admin, except: [:index, :show, :add_team]

  # GET /tournaments
  # GET /tournaments.json
  def index
    @tournaments = Tournament.all
  end

  # GET /tournaments/1
  # GET /tournaments/1.json
  def show
  end

  # GET /tournaments/new
  def new
    @tournament = Tournament.new
  end

  # GET /tournaments/1/edit
  def edit
  end

  # POST /tournaments
  # POST /tournaments.json
  def create
    @tournament = current_user.tournaments.new(tournament_params)

    respond_to do |format|
      if @tournament.save
        format.html { redirect_to @tournament, notice: 'Tournament was successfully created.' }
        format.json { render :show, status: :created, location: @tournament }
      else
        format.html { render :new }
        format.json { render json: @tournament.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tournaments/1
  # PATCH/PUT /tournaments/1.json
  def update
    respond_to do |format|
      if @tournament.update(tournament_params)
        format.html { redirect_to @tournament, notice: 'Tournament was successfully updated.' }
        format.json { render :show, status: :ok, location: @tournament }
      else
        format.html { render :edit }
        format.json { render json: @tournament.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tournaments/1
  # DELETE /tournaments/1.json
  def destroy
    @tournament.destroy
    respond_to do |format|
      format.html { redirect_to tournaments_url, notice: 'Tournament was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def add_team
    if !params[:tournament].nil?
      team = Team.find_by(id: params[:tournament][:team_ids])

      if !@tournament.teams.exists?(team)
        if @tournament.teams.length == @tournament.teams_count
          flash['danger'] = 'There is no slots left'
        else
          @tournament.teams<<(team)
          flash['notice'] = 'Your team has been singed up to this tournament'
        end
      else
        flash['danger'] = 'Your team is already signed up to this tournament'
      end
    end

    redirect_to @tournament
  end

  def generate
    teams = @tournament.teams.shuffle

    @tournament.matches.clear

    matches_count = @tournament.teams_count - 1
    first_round_matches_count = @tournament.teams_count / 2
    rounds = Math.log2(@tournament.teams_count).round
    current_round = 0

    matches = []

    matches_count.times { matches << { } }
    matches = @tournament.matches.build(matches)

    first_round_matches_count.times do |i|
      matches[i].update_attributes({ round_id: current_round, home: teams[i * 2], away: teams[i * 2 + 1],
                                   next_match: matches[first_round_matches_count + i / 2]})
    end


    current_round = 1
    match_id = first_round_matches_count * 1.5
    id = first_round_matches_count
    (rounds-1).downto(1) do |round|
      for m in 0..Math.log2(round)
        matches[id].update_attributes({ round_id: current_round, next_match: matches[match_id] })
        id += 1
        if m % 2 == 1
          match_id +=1
        end
      end
      current_round += 1
    end

    matches.each { |m| m.save }
    @tournament.update(generated: true)

    flash[:notice] = 'Bracket has been generated'
    redirect_to @tournament

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tournament
      @tournament = Tournament.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tournament_params
      params.require(:tournament).permit(:name, :start_date, :teams_count, :started)
    end

    def require_tournament_admin
      redirect_to @tournament, flash: { danger: 'You must be admin to edit' } unless helpers.tournament_admin?
    end
end
