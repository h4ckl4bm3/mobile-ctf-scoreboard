class FlagSubmissionsController < ApplicationController
  before_filter :enforce_access

  def index
    # Shows flag submitted listing (which team, when, and success)
  end

  def show
    # Shows flag submission (which team, when, what flag was tried, and success)
  end

  def create
    # Used to submit a new flag
    submitted_time = Time.now.to_i
    defending_team = User.find(params[:team])
    flag_find = defending_team.flags.find_by(flag: params[:flag]) if defending_team
    time_range = nil
    time_range = flag_find?.attack_period.start.to_i..flag?.attack_period.finish.to_i if flag_find
    # need to add round, possibly automate check with before_create
    new_fs = FlagSubmission.new(user: current_user, flag: params[:flag])
    new_fs.owner = defending_team if defending_team
    if(time_range === submitted_time)
      # add the success factor here
      new_fs[:success] = true
      new_fs.save
      @defending_team = defending_team
      @success = true
    else
      new_fs[:success] = false
      new_fs.save
      @success = false
    end
  end
end
