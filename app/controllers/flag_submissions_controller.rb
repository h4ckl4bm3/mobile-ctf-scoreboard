class FlagSubmissionsController < ApplicationController
  before_filter :enforce_access
  def index
    # Shows flag submitted listing (which team, when, and success)
    @flag_submissions = current_user.flag_submissions.order(submitted_at: :desc)
  end

  def show
    # Shows flag submission (which team, when, what flag was tried, and success)
  end

  def create
    #Ensure they are not capturing their own flag or the same team's flag multiple times

    # Used to submit a new flag
    defending_team = User.find_by_id(params[:team])
    defending_team = nil unless defending_team
    if defending_team == current_user
      @defending_team = "NICE TRY"
      @success = true
    else
      new_fs = FlagSubmission.create(user: current_user, flag: params[:flag], owner: defending_team)
      @defending_team = new_fs.owner.display_name if new_fs.owner
      @success = new_fs.success
    end
  end
end
