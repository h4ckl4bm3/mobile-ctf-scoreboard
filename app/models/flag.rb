class Flag < ActiveRecord::Base
  belongs_to :user
  belongs_to :attack_period

  def times_stolen
    FlagSubmissions.where(flag: self.flag, owner: self.user, attack_period: self.attack_period).count
  end

  # Should auto assign to specific AttackPeriod
  before_save do
    # If attack period is assigned, then use it, if not, find the current Attack Period and use that
    submitted_time = Time.now
    unless self.attack_period
      self.attack_period = AttackPeriod.find_by('start <= :submitted_time and :submitted_time <= finish', {submitted_time: submitted_time})
    end
  end
end
