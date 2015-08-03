require 'csv'
namespace :mobile_ctf_scoreboard do

  desc "Load player into the DB"
  task :load_player, [:player_login, :password, :player] => :environment do |t, args|
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
  task :load_round, [:start, :finish] => :environment do |t, args|
    start = if args[:start] then args[:start].to_time else Time.now end
    round = Round.new(start: start)
    if args[:finish]
      round[:finish] = args[:finish].to_time
    end
    round.save!
  end

  # Was thinking we may need defend, but that may not be necessary (it's just when attack doesn't exist)
  desc "Create new defend period, offset moves start time up, start defaults now, offset defaults 0, duration defaults 15"
  task :load_defend_period, [:duration_in_minutes, :offset_in_minutes, :start] => :environment do |t, args|
    start = if args[:start] then args[:start].to_time else Time.now end
    offset = if args[:offset_in_minutes] then args[:offset_in_minutes].to_i else 0 end
    duration = if args[:duration_in_minutes] then args[:duration_in_minutes].to_i else 15 end
    actualStart = start + offset*60
    DefendPeriod.create!(start: actualStart, finish: actualStart + duration*60)
  end

  # Was thinking we may need defend, but that may not be necessary (it's just when attack doesn't exist)
  desc "Create new attack period, offset moves start time up, start defaults now, offset defaults 0, duration defaults 15"
  task :load_attack_period, [:duration_in_minutes, :offset_in_minutes, :start] => :environment do |t, args|
    start = if args[:start] then args[:start].to_time else Time.now end
    offset = if args[:offset_in_minutes] then args[:offset_in_minutes].to_i else 0 end
    duration = if args[:duration_in_minutes] then args[:duration_in_minutes].to_i else 15 end
    actualStart = start + offset*60
    AttackPeriod.create!(start: actualStart, finish: actualStart + duration*60)
  end

  desc "Load flags for all users in DB, attack_start defaults to now"
  task :load_flags_for_period, [:attack_start] => :environment do |t, args|
    # May want to prevent multiple flags from being loaded during the
    Player.find_each do |player|
      flag = Flag.new(user: player, flag: "#{args[:flag]}")
      if args[:attack_start]
        start = args[:attack_start].to_time
        # set attack_period to exist with attack_start args[:attack_start]
        flag.attack_period = AttackPeriod.find_by('start <= :submitted_time and :submitted_time <= finish', {submitted_time: start})
      end
      flag.save!
    end
  end

  desc "Load test flag submissions"
  task :load_test_flag_submissions_for_period, [:user, :owner, :flag, :attack_start] => :environment do |t, args|
    # May want to prevent multiple flags from being loaded during the
    flag_submission = FlagSubmission.new()
  end

end
