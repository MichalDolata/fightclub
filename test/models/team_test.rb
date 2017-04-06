require 'test_helper'

class TeamTest < ActiveSupport::TestCase
  def setup
    @team = Team.new(name: 'TestTeam', user_id: User.first.id)
  end

  test 'name should exist and be in range <3; 32>' do
    @team.name = 'Ab'
    assert_not @team.valid?

    @team.name = 'abc'
    assert @team.valid?

    @team.name = 'a' * 32
    assert @team.valid?

    @team.name = 'a' * 33
    assert_not @team.valid?

    @team.name = ''
    assert_not @team.valid?

    @team.name = nil
    assert_not @team.valid?
  end

  test 'name should be unique' do
    team_dup = @team.dup
    @team.save
    assert_not team_dup.valid?

    team_dup.name.downcase!
    assert_not team_dup.valid?
  end
end
