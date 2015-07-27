require 'csv'
namespace :mobile_ctf_scoreboard do
  desc "Load base test data into the DB"
  task load_test_data: :environment do
    CSV.foreach(Rails.root.join('resources', 'test_players.csv'))  do |row|
      Player.create(email: row[0], password: row[1], display_name: row[2], game_id: 0)
    end
  end

end
