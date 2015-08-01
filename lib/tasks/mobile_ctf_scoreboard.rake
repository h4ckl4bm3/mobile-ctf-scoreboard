require 'csv'
namespace :mobile_ctf_scoreboard do

  desc "Load user into the DB"
  task :load_user, [:player_login, :player, :password] => :environment do |t, args|
    p = Player.find_by_email("#{args[:player_login]}")
    if p.nil?
      p = Player.create(email: "#{args[:player_login]}", password: "#{args[:password]}", display_name: "#{args[:player]}", game_id: nil)
    else
      puts "User Exists"
    end
  end

  desc "Create new round (end is indeterminate, only until we say it ends), start defaults to now"
  # Honestly, we may want to setup all rounds at the beginning (though this may be difficult with integrity checks)
  task :load_round, [:start] => :environment do |t, args|
    start = args[:start] || Time.now
    Round.create(start: actualStart, finish: actualStart + duration*60)
  end

  # Was thinking we may need defend, but that may not be necessary (it's just when attack doesn't exist)
  desc "Create new defend period, offset moves start time up, start defaults now, offset defaults 0, duration defaults 15"
  task :load_defend_period, [:duration_in_minutes, :offset_in_minutes, :start] => :environment do |t, args|
    start = args[:start] || Time.now
    offset = args[:offset_in_minutes] || 0
    duration = args[:duration_in_minutes] || 15
    actualStart = start + offset*60
    DefendPeriod.create(start: actualStart, finish: actualStart + duration*60)
  end

  # Was thinking we may need defend, but that may not be necessary (it's just when attack doesn't exist)
  desc "Create new attack period, offset moves start time up, start defaults now, offset defaults 0, duration defaults 15"
  task :load_attack_period, [:duration_in_minutes, :offset_in_minutes, :start] => :environment do |t, args|
    start = args[:start] || Time.now
    offset = args[:offset_in_minutes] || 0
    duration = args[:duration_in_minutes] || 15
    actualStart = start + offset*60
    AttackPeriod.create(start: actualStart, finish: actualStart + duration*60)
  end

  desc "Load flag into the DB"
  task :load_flag, [:user_id, :flag] => :environment do |t, args|
    # May want to prevent multiple flags from being loaded during the
    Flag.create(user: user_id, flag: "#{args[:flag]}")
  end

end
