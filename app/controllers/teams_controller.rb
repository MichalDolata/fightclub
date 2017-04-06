class TeamsController < ApplicationController
  before_action :require_login, except: [:index]
  before_action :correct_user, only: [:edit, :update, :destroy]

  def index
    @teams = Team.all
  end

  def new
    @team = Team.new
  end

  def create
    @team = current_user.teams.new(team_params)
    if @team.save
      flash[:notice] = 'Team has beed created'
      redirect_to root_path
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @team.update_attributes(team_params)
      flash[:notice] = 'Team has been updated'
      redirect_to root_path
    else
      render 'edit'
    end
  end

  def destroy
    @team.destroy
    flash[:notice] = 'Team has been remove'
    redirect_to root_path
  end

  private

  def team_params
    params.require(:team).permit(:name, :description)
  end

  def correct_user
    @team = current_user.teams.find_by(id: params[:id])
    redirect_to root_path if @team.nil?
  end
end
