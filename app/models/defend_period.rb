# This class is only useful for determining if code uploads are valid
class DefendPeriod < ActiveRecord::Base
  belongs_to :round

  # Should auto assign to specific Round
  before_save do
    # Use start to assign Round
    self.round = Round.find_by('start <= :start and (:finish <= finish or finish is null)', {start: self[:start], finish: self[:finish]})
  end
end
