class FlagSubmissionsController < ApplicationController
  before_filter :enforce_access

  def index
    # Shows flag submitted listing (which team, when, and success)
    @flag_submissions = current_user.flag_submissions
  end

  def show
    # Shows flag submission (which team, when, what flag was tried, and success)
  end

  def create
    #Ensure they are not capturing their own flag or the same team's flag multiple times

    # Used to submit a new flag
    defending_team = User.find(params[:team])
    new_fs = FlagSubmission.create(user: current_user, flag: params[:flag], owner: defending_team)
    @defending_team = defending_team
    @success = true
  end
end
