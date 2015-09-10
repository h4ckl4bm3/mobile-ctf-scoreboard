class PlayersController < ApplicationController

  UPLOAD_PACKAGE_PATH = Rails.application.config.assets.package_store_path
  BASE_CHALLENGE_PATH = Rails.application.config.assets.challenge_base
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
    # IDEA can only access if there is an attack period
    if player
      # Assumes Attack and Defend Periods share pairs of ids
      @attack_period = AttackPeriod.find_by('start <= :now and (finish is null or :now <= finish)', {now: Time.now})
      @round = Round.find_by('start <= :now and (:now <= finish or finish is null)', {now: Time.now})
      # Assumes failures have been modified to be the base
      if @attack_period
        directory = "#{UPLOAD_PACKAGE_PATH}#{@attack_period.id}"
        file_path = File.join(directory, "/#{player.id.to_s}.apk")
        if File.exists?(file_path)
          send_file(file_path, filename: "team#{player.id}_#{challenge_folder}.apk")
        else
          @error_message = "no challenge apk available for this team."
        end
      else
        @error_message = "no attack period currently running. Please check back during the next attack period."
      end
    else
      @error_message = "player not found."
    end
    @title = "Challenge app download error"
  end

  def download_challenge_base
    # IDEA should we allow access when there is no defend period?
    @round = Round.find_by('start <= :now and (:now <= finish or finish is null)', {now: Time.now})
    if @round
      challenge_folder = "challenge#{@round.id}"
      base = "#{BASE_CHALLENGE_PATH}#{CHALLENGE_FOLDERS[challenge_folder.intern]}/app.zip"
      puts base
      if File.exists?(base)
        send_file(base, filename: "#{challenge_folder}.zip")
      else
        @error_message = "no challenge folder zip found."
      end
    else
      @error_message = "no round currently running."
    end
    @title = "Base source app download error"
  end
end
