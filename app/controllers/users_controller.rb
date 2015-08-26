class UsersController < ApplicationController
  before_filter :enforce_access, only: [ :myteam, :upload_package ]
  def index
    @teams = Player.all
    @title = "Teams"
  end

  def myteam
    @player = current_user
    round = Round.find_by('start <= :round_time and (finish is null or :round_time <= finish)', {round_time: Time.now})
    @failed_integrities_for_round = current_user.integrities.where(round:round, success: false).count if round
    @failed_integrities = current_user.integrities.where(success: false).count

    @flag_submissions_for_round = current_user.flag_submissions.joins(:attack_period).where('attack_periods.round_id' => round).count if round
    @flag_submissions_success_for_round = current_user.flag_submissions.joins(:attack_period).where('attack_periods.round_id' => round, success: true).count if round
    @flag_submissions = current_user.flag_submissions.all.count
    @flag_submissions_success = current_user.flag_submissions.where(success: true).count

    @flag_steal_attempts_for_round = FlagSubmission.where(owner: current_user).joins(:attack_period).where('attack_periods.round_id' => round).count if round
    @flag_steal_successes_for_round = FlagSubmission.where(owner: current_user, success: true).joins(:attack_period).where('attack_periods.round_id' => round).count if round
    @flag_steal_attempts = FlagSubmission.where(owner: current_user).count
    @flag_steal_successes = FlagSubmission.where(owner: current_user, success: true).count
    # @flags_submitted = to_timeline FlagSubmission.where("user_id=?",params[:id]).group_by {|sf| sf.updated_at.change(:sec=>0)}
    @score_for_round = @player.score_for_round
    @score = @player.score
    @title = @player.display_name

    render :myteam
  end

  def upload_package
    defense_period = DefendPeriod.find_by('start <= :current_time and (finish is null or :current_time <= finish)', {current_time: Time.now})
    # Exit if not currently a defense period.  Should send error back when none found
    @title = "Failure!"
    @error_messages = []
    @error_messages << "The defense period is over/not currently running" unless defense_period
    @error_messages << "The defense period is over/not currently running" unless File.extname(params[:app].original_filename) == ".zip"
    return if @error_messages.length > 0
    @title = "Success!"
    file_name = current_user.id.to_s + '.zip'
    dir = File.dirname("#{Rails.root}/packages/#{defense_period.id}/my.log")
    FileUtils.mkdir_p(dir) unless File.directory?(dir)
    File.open(Rails.root.join('packages', defense_period.id.to_s, file_name), 'wb') do |file|
      file.write(params[:app].read)
    end
  end
end
