class PlayersController < ApplicationController

  UPLOAD_PACKAGE_PATH = Rails.application.config.assets.package_store_path
  BASE_CHALLENGE_PATH = Rails.application.config.assets.challenge_folders
  CHALLENGE_FOLDERS = Rails.application.config.assets.challenge_folders

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
    directory = "#{UPLOAD_PACKAGE_PATH}#{@last_defense_period.id}"
    file_path = File.join(directory, file_name)
    FileUtils.mkdir_p(directory) unless File.directory?(directory)
    File.open(file_path, 'wb') do |file|
      file.write(params[:app].read)
    end
  end

  def download_challenge_app
    player = Player.find_by(id: params[:id])
    # IDEA should we allow access when there is no attack period?
    if player
      @last_defense_period = DefendPeriod.where('finish <= :current_time', {current_time: Time.now}).order(finish: :desc).first
      if @last_defense_period
        directory = "#{UPLOAD_PACKAGE_PATH}#{@last_defense_period.id}"
        file_path = File.join(directory, "/#{player.id.to_s}.zip")
        send_file(file_path) if File.exists?(file_path)
      else
        # return the base_app
        base_challenge_app = "#{@last_defense_period.id}" # TODO fill this in with where this is located
        send_file(base_challenge_app) if File.exists?(base_challenge_app)
      end
    end
  end

  def download_challenge_base
    # IDEA should we allow access when there is no attack period?
    @round = Round.find_by('start <= :now and (:now <= finish or finish is null)', {now: Time.now})
    if @round
      challenge_folder = "challenge#{@round.id}"
      directory = "#{BASE_CHALLENGE_PATH}#{CHALLENGE_FOLDERS[challenge_folder.intern]}"
      puts directory
    end
  end
end
