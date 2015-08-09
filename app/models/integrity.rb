class Integrity < ActiveRecord::Base
  belongs_to :user
  # Maybe use attakc or defend here, since there can be multiple per round?
  belongs_to :round
  before_save do
    # Use start to assign Round
    self.submitted_at = Time.now unless self.submitted_at
    self.round = Round.find_by('start < :submitted_at and :submitted_at <= finish', {submitted_at: self.submitted_at})
  end
end
