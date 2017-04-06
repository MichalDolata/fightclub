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
    #generate matches
    #set genearted to true
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
