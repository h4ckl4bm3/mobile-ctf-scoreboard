class UsersController < ApplicationController
  before_filter :enforce_access, except: [ :index ]
  def index
    @teams = Player.all.order(:id)
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
    @error_messages << "Improper file type (should be .zip)" unless File.extname(params[:app].original_filename) == ".zip"
    return if @error_messages.length > 0
    @title = "Success!"
    file_name = current_user.id.to_s + '.zip'
    directory = "/opt/packages/#{defense_period.id}"
    file_path = File.join(directory, file_name)
    FileUtils.mkdir_p(directory) unless File.directory?(directory)
    File.open(file_path, 'wb') do |file|
      file.write(params[:app].read)
    end
  end

  def download_challenge_app
    player = Player.find_by(id: params[:id])
    # IDEA should we allow acces when there is no attack period?
    if player
      @last_defense_period = DefendPeriod.where('finish <= :current_time', {current_time: Time.now}).order(finish: :desc).first
      if @last_defense_period
        directory = "/opt/packages/#{@last_defense_period.id}"
        file_path = File.join(directory, "/#{params[:id].to_s}.zip")
        send_file(file_path) if File.exists?(file_path)
      else
        # return the base_app
        base_challenge_app = "#{@last_defense_period.id}" # TODO fill this in with where this is located
        send_file(base_challenge_app) if File.exists?(base_challenge_app)
      end
    end
  end
end
