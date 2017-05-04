require 'test_helper'

class TournamentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    @tournament = tournaments(:one)
  end

  test 'test calculating number of rounds' do
    @tournament.teams_count = 16
    assert_equal 4, @tournament.rounds

    @tournament.teams_count = 2
    assert_equal 1, @tournament.rounds

    @tournament.teams_count = 8
    assert_equal 3, @tournament.rounds
  end
end
