class FlagSubmission < ActiveRecord::Base
  belongs_to :user
  belongs_to :owner, class_name: "User", foreign_key: 'owner_id'
  belongs_to :attack_period

  # Should auto assign to specific AttackPeriod
  before_save do
    # Assign an attack period (if not already done)
    submitted_time = Time.now
    unless self.attack_period
      self.attack_period = AttackPeriod.find_by('start < :submitted_time and :submitted_time < finish', {submitted_time: submitted_time})
    end
    # Perform success check and apply
    flag_find = self.owner.flags.find_by(flag: self.flag, attack_period: self.attack_period) if self.owner
    # need to add round, possibly automate check with before_create
    if flag_find
      self.success = true
    else
      self.success = false
    end
  end
end
