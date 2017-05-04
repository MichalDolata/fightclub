module ResultsHelper
  def result_added?
    Result.find_by(match: @match, captain: current_user)
  end
end
