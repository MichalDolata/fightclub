module TournamentsHelper
  def tournament_admin?
    current_user == @tournament.creator
  end
end