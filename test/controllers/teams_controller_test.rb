require 'test_helper'

class TeamsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:admin)
    @user = users(:regular_user)
    @team = teams(:vp)
  end

  test "should get index" do
    get teams_url
    assert_response :success
  end

  test 'should create new team' do
    log_in_as(@user)

    assert_difference('Team.count') do
      post teams_path, params: { team: { name: 'test', description: 'test'} }
    end

    assert_redirected_to root_path
    assert_not flash.empty?
  end

  test 'only logged users can create' do
    assert_no_difference('Team.count') do
      post teams_path, params: { team: { name: 'test', description: 'test'} }
    end
  end

  test 'only owner of the team can edit and destroy it' do
    log_in_as(@user)

    name_before = @team.name
    patch team_path(@team), params: { team: { name: 'test', description: 'test'} }
    @team.reload
    assert_equal @team.name, name_before

    assert_no_difference('Team.count') do
      delete team_path(@team)
    end


    log_in_as(@admin)

    name_before = @team.name
    patch team_path(@team), params: { team: { name: 'test', description: 'test'} }
    @team.reload
    assert_not_equal @team.name, name_before

    # assert_difference doesn't work?

    before_count = Team.count
    delete team_path(@team)
    assert_equal before_count - 1, Team.count
  end
end
