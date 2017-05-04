class TournamentsController < ApplicationController
  before_action :set_tournament, except: [:index, :new, :create]
  before_action :require_login, except: [:index, :show]
  before_action :require_tournament_admin, except: [:index, :new, :create, :show, :add_team]

  # GET /tournaments
  # GET /tournaments.json
  def index
    @tournaments = Tournament.all.includes(:creator)
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
      update_params = tournament_params
      update_params.except!(:teams_count) unless @tournament.signup_mode?
      if @tournament.update(update_params)
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
    if @tournament.signup_mode? && !params[:tournament].nil?
      team = Team.find_by(id: params[:tournament][:team_ids])

      if !@tournament.teams.exists?(team)
        if @tournament.teams.length >= @tournament.teams_count
          flash['danger'] = 'There is no slots left'
        else
          @tournament.teams << team
          flash['notice'] = 'Your team has been singed up to this tournament'
        end
      else
        flash['danger'] = 'Your team is already signed up to this tournament'
      end
    else
      flash['danger'] = 'Registraion for this tournament has been closed'
    end

    redirect_to @tournament
  end

  def generate
    # Check if number of team is valid
    if @tournament.teams.length <= @tournament.teams_count / 2
      flash['danger'] = 'Not enough teams to generate the bracket'
    elsif @tournament.teams.length > @tournament.teams_count
      flash['danger'] = 'Too many teams to generate the bracket'
    else
      @tournament.generate_bracket

      flash[:notice] = 'Bracket has been generated'
    end

    redirect_to @tournament

  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_tournament
      @tournament = Tournament.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tournament_params
      params.require(:tournament).permit(:name, :start_date, :teams_count)
    end


end
