class Player < User

  has_many :messages, foreign_key: :user_id
  has_many :integrities, foreign_key: :user_id
  has_many :flags, foreign_key: :user_id # contains all flags over each round
  has_many :flag_submissions, foreign_key: :user_id # contains both their submissions and the other teams
  has_many :user_messages, foreign_key: :user_id
  has_many :messages, through: :user_messages, foreign_key: :user_id


  def score
    # Still need to figure this out
    flag_points = 0
    self.flags.each do |flag|
      flag_points += flag.attack_period.flag_point_value - flag.times_stolen*(flag.attack_period.flag_point_value/Player.all.count) if flag.attack_period
    end
    integrity_points = 0
    self.integrities.each do |integrity|
      integrity_points -= integrity.round.integrity_point_value if not integrity.success and integrity.round
    end
    flag_submission_points = 0
    self.flag_submissions.each do |flag_submission|
      flag_submission_points += flag_submission.attack_period.submission_point_multiplier*(flag_submission.attack_period.flag_point_value/Player.all.count) if flag_submission.success and flag_submission.attack_period
    end
    points = flag_points + integrity_points + flag_submission_points
    points
  end

  def score_for_round
    round = Round.find_by('start <= :round_time and (finish is null or :round_time <= finish)', {round_time: Time.now})
    flag_points = 0
    self.flags.each do |flag|
      flag_points += flag.attack_period.flag_point_value - flag.times_stolen*(flag.attack_period.flag_point_value/Player.all.count) if flag.attack_period and flag.attack_period.round == round
    end
    integrity_points = 0
    self.integrities.each do |integrity|
      integrity_points -= integrity.round.integrity_point_value if not integrity.success and integrity.round and integrity.round == round
    end
    flag_submission_points = 0
    self.flag_submissions.each do |flag_submission|
      flag_submission_points += flag_submission.attack_period.submission_point_multiplier*(flag_submission.attack_period.flag_point_value/Player.all.count) if flag_submission.success and flag_submission.attack_period and flag_submission.attack_period.round == round
    end
    points =  flag_points + integrity_points + flag_submission_points
    points
  end

end
