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
    task :round, [:start, :finish] => :environment do |t, args|
      start = if args[:start] then args[:start].to_time else Time.now end
      round = Round.new(start: start)
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
    task :attack_period, [:duration_in_minutes, :offset_in_minutes, :start] => :environment do |t, args|
      start = if args[:start] then args[:start].to_time else Time.now end
      offset = if args[:offset_in_minutes] then args[:offset_in_minutes].to_i else 0 end
      duration = if args[:duration_in_minutes] then args[:duration_in_minutes].to_i else 15 end
      actualStart = start + offset*60
      AttackPeriod.create!(start: actualStart, finish: actualStart + duration*60)
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
    end
  end
  namespace :test do
    desc "Load test flag submissions"
    task :flag_submissions_for_period, [:user_id, :owner, :success, :attack_start] => :environment do |t, args|
      # May want to prevent multiple flags from being loaded during the
      user = User.find_by_id(args[:user_id])
      flag_submission = FlagSubmission.new()
    end
  end

end
