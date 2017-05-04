require 'test_helper'

class MatchTest < ActiveSupport::TestCase
  def setup
    @home = teams(:vp)
    @away = teams(:tsm)
    @tournament = tournaments(:one)
    @match = @tournament.matches.new(home: @home, away: @away, next_match: nil, status: :active)
  end

  test 'should return valid winner' do
    @match.home_score = 2
    @match.away_score = 1

    assert_equal @home, @match.pick_winner

    @match.home_score = 1
    @match.away_score = 2

    assert_equal @away, @match.pick_winner

    @match.home_score = 1
    @match.away_score = 1

    assert_not @match.pick_winner
  end

  test 'should have winner to close' do
    @match.away_score = 1
    @match.home_score = 1

    assert_not @match.close

    assert_equal 'active', @match.status

    @match.away_score = 1
    @match.home_score = 2

    assert_not_nil @match.close

    assert_equal 'closed', @match.status
  end
end
