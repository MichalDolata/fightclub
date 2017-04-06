class CreateJoinTableTeamTournament < ActiveRecord::Migration[5.0]
  def change
    create_join_table :teams, :tournaments do |t|
      # t.index [:team_id, :tournament_id]
      #t.index [:tournament_id, :team_id]
    end
  end
end
