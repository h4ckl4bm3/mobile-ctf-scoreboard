require 'csv'
namespace :mobile_ctf_scoreboard do

  namespace :load do
    desc "Load player into the DB"
    task :player, [:player_login, :password, :player] => :environment do |t, args|
      p = Player.find_by_email("#{args[:player_login]}")
      if p.nil?
        p = Player.create!(email: "#{args[:player_login]}", password: "#{args[:password]}", display_name: "#{args[:player]}", game_id: nil)
      else
        puts "User Exists"
      end
    end

    # May want to add check to make sure things don't overlap (attack/defend periods, rounds, etc.)

    desc "Create new round (end is indeterminate, only until we say it ends), start defaults to now"
    # Honestly, we may want to setup all rounds at the beginning (though this may be difficult with integrity checks)
    task :round, [:integrity_point_value, :start, :finish] => :environment do |t, args|
      start = if args[:start] then args[:start].to_time else Time.now end
      round = Round.new(start: start, integrity_point_value: args[:integrity_point_value])
      if args[:finish]
        round[:finish] = args[:finish].to_time
      end
      round.save!
    end

    # Was thinking we may need defend, but that may not be necessary (it's just when attack doesn't exist)
    desc "Create new defend period, offset moves start time up, start defaults now, offset defaults 0, duration defaults 15"
    task :defend_period, [:duration_in_minutes, :offset_in_minutes, :start] => :environment do |t, args|
      start = if args[:start] then args[:start].to_time else Time.now end
      offset = if args[:offset_in_minutes] then args[:offset_in_minutes].to_i else 0 end
      duration = if args[:duration_in_minutes] then args[:duration_in_minutes].to_i else 15 end
      actualStart = start + offset*60
      DefendPeriod.create!(start: actualStart, finish: actualStart + duration*60)
    end

    # Was thinking we may need defend, but that may not be necessary (it's just when attack doesn't exist)
    desc "Create new attack period, offset moves start time up, start defaults now, offset defaults 0, duration defaults 15"
    task :attack_period, [:flag_points, :submission_point_multiplier, :duration_in_minutes, :offset_in_minutes, :start] => :environment do |t, args|
      start = if args[:start] then args[:start].to_time else Time.now end
      offset = if args[:offset_in_minutes] then args[:offset_in_minutes].to_i else 0 end
      duration = if args[:duration_in_minutes] then args[:duration_in_minutes].to_i else 15 end
      actualStart = start + offset*60
      AttackPeriod.create!(start: actualStart, finish: actualStart + duration*60, flag_point_value: args[:flag_points], submission_point_multiplier: args[:submission_point_multiplier])
    end

    desc "Load flags for all users in DB, attack_start defaults to now"
    task :flags_for_period, [:attack_start, :flag] => :environment do |t, args|
      # May want to prevent multiple flags from being loaded during the
      Player.find_each do |player|
        flag = Flag.new(user: player, flag: args[:flag])
        if args[:attack_start]
          start = args[:attack_start].to_time
          # set attack_period to exist with attack_start args[:attack_start]
          flag.attack_period = AttackPeriod.find_by('start <= :submitted_time and :submitted_time <= finish', {submitted_time: start})
        end
        flag.save!
      end
    end

    desc "Load integrity check result"
    task :integrity_check_result, [:user_id, :success, :submitted_at] => :environment do |t, args|
      generated_at = args[:submitted_at].to_time if args[:submitted_at]
      user = User.find_by_id(args[:user_id])
      Integrity.create!(user: user, success: args[:success], submitted_at: generated_at)
    end

    namespace :message do
      desc 'Send message to a user'
      task :to_user, [:user_id, :subject, :message, :sent_at] => [:environment] do |t, args|
        sent_at = args[:sent_at].to_time if args[:sent_at]
        message = Message.create!(subject: args[:subject], message: args[:message], sent_at: sent_at, sent_to: 'User')
        user = User.find_by_id(args[:user_id])
        UserMessage.create!(user: user, message: message)
      end

      desc 'Send message to all users'
      task :to_all, [:subject, :message, :sent_at] => [:environment] do |t, args|
        sent_at = args[:sent_at].to_time if args[:sent_at]
        message = Message.create!(subject: args[:subject], message: args[:message], sent_at: sent_at, sent_to: 'All')
        Player.find_each do |player|
          UserMessage.create!(user: player, message: message)
        end
      end

      desc 'Zip packages'
      task :zip_packages, [:subject, :message, :sent_at] => [:environment] do |t, args|
        sent_at = args[:sent_at].to_time if args[:sent_at]
        message = Message.create!(subject: args[:subject], message: args[:message], sent_at: sent_at, sent_to: 'All')
        Player.find_each do |player|
          UserMessage.create!(user: player, message: message)
        end
      end
    end
  end
  namespace :update do
    desc "Modify current round to give it an end"
    # Honestly, we may want to setup all rounds at the beginning (though this may be difficult with integrity checks)
    task :end_round, [:finish] => :environment do |t, args|
      round = Round.find_by('start <= :current and (:current <= finish or finish is null)', {current: Time.now})
      if round
        round[:finish] = if args[:finish] then args[:finish].to_time else Time.now end
      end
      round.save!
    end
  end
  namespace :manage do
    desc "Test each apps integrity"
    task :integrity_test => :environment do |t, args|
      defense_period = DefendPeriod.where('finish <= :current_time', {current_time: Time.now}).order(finish: :desc).first
      storage_base = "/opt/packages/#{defense_period.id}"
      Player.find_each do |player|
        # Get the most recent defend period id
        file_path = storage_base + "/#{player.id}"
        File.open(file_path, 'rb') do |file|
          # run command to unzip and test the apk

          # either the command or the result will apply to the integrity
        end if File.exists?(file_path)
      end
    end
    desc "Place apps in a public directory"
    task :make_challenges_public => :environment do |t, args|
      defense_period = DefendPeriod.where('finish <= :current_time', {current_time: Time.now}).order(finish: :desc).first
      storage_base = "/opt/packages/#{defense_period.id}"
      pub_directory = "public/packages/#{defense_period.id}"
      base_package = "" # TODO fill in
      FileUtils.mkdir_p(directory) unless File.directory?(directory)
      Player.find_each do |player|
        # Get the most recent defend period id
        current_file_path = storage_base + "/#{player.id}"
        public_file_path = pub_directory + "/#{player.id}"
        if File.exists?(current_file_path) and player.integrities.last.success
          File.open(current_file_path, 'rb') do |app|
            File.open(public_file_path, 'wb') do |pub|
              pub.write(app.read)
            end
          end
        else
          File.open(base_package, 'rb') do |app|
            File.open(public_file_path, 'wb') do |pub|
              pub.write(app.read)
            end
          end
        end
      end
    end
    desc "Challenge server startup"
    task :challenge_server_startup, [:challenge, :host, :starting_port, :app_sig, :opts] => :environment do |t, args|
      challenge server = "" # TODO fill in where to retrieve and how
      Player.find_each do |player|
        port = args[:starting_port] + player.id # Unique port for each player
        run_server(challenge_path, args[:host], port, args[:flag], args[:opts])
      end
    end
    desc "Dummy server startup"
    task :dummy_server_startup, [:challenge, :host, :starting_port, :opts] => :environment do |t, args|
      challenge_path = "" # TODO fill in where to retrieve and how
      port = args[:starting_port]
      run_server(challenge_path, args[:host], port, 'foundme', args[:db_name], args[:db_user], args[:db_pass])
    end

    def run_server(challenge_path, type, host, port, flag, opts)
      # may want to come up with another way to kill the current process on the port
      `sudo kill -9 $(sudo lsof -t -i:#{port})`
      puts `flag=#{flag} host=#{host} port=#{port} opts=#{opts.to_s} ruby #{challenge_path}`
    end
  end

  namespace :test do
    desc "Load successful test flag submissions"
    task :successful_flag_submissions_for_period, [:user_id, :owner_id, :attack_start] => :environment do |t, args|
      # May want to prevent multiple flags from being loaded during the
      user = User.find_by_id(args[:user_id])
      owner = User.find_by_id(args[:owner_id])
      submitted_at = Time.now
      submitted_at = args[:attack_start].to_time if args[:attack_start]
      attack_period = AttackPeriod.find_by('start < :submitted_at and :submitted_at < finish', {submitted_at: submitted_at})
      flag_obj = owner.flags.find_by(attack_period: attack_period)
      flag = flag_obj.flag if flag_obj
      flag_submission = FlagSubmission.create(user: user, owner: owner, submitted_at: submitted_at, attack_period: attack_period, flag: flag)
    end
      desc "Load failing flag submissions"
      task :failing_flag_submissions_for_period, [:user_id, :owner_id, :attack_start] => :environment do |t, args|
        # May want to prevent multiple flags from being loaded during the
        user = User.find_by_id(args[:user_id])
        owner = User.find_by_id(args[:owner_id])
        submitted_at = Time.now
        submitted_at = args[:attack_start].to_time if args[:attack_start]
        attack_period = AttackPeriod.find_by('start < :submitted_at and :submitted_at < finish', {submitted_at: submitted_at})
        flag = "Guess this was meant to fail"
        flag_submission = FlagSubmission.create!(user: user, owner: owner, submitted_at: submitted_at, attack_period: attack_period, flag: flag)
      end
  end

end
