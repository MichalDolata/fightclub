module TeamsHelper
  def team_captain?(team)
    current_user && current_user.teams.find_by(id: team.id)
  end
end
