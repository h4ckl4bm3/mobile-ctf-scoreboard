class FlagSubmission < ActiveRecord::Base
  belongs_to :user
  belongs_to :owner, class_name: "User", foreign_key: 'owner_id'
  belongs_to :attack_period

  # Should auto assign to specific AttackPeriod
  before_save do
    # Assign an attack period (if not already done)
    self.submitted_at = Time.now unless self.submitted_at  
    self.attack_period = AttackPeriod.find_by('start < :submitted_at and :submitted_at < finish', {submitted_at: self.submitted_at}) unless self.attack_period
    # Perform success check and apply
    self.success = if self.owner and self.owner.flags.find_by(flag: self.flag, attack_period: self.attack_period)
      true
    else
      false
    end
    true
  end
end
