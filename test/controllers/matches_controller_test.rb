require 'test_helper'

class MatchesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @match = matches(:one)
    @tournament = @match.tournament
  end

  test 'match should be updated only if active' do
    log_in_as(users(:admin))

    patch tournament_match_path(@tournament, @match), params: { match: { home_score: 2, away_score: 3} }

    @match.reload
    assert_equal 2, @match.home_score
    assert_equal 3, @match.away_score
  end
end
