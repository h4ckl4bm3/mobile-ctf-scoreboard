class AttackPeriod < ActiveRecord::Base
  belongs_to :round
  belongs_to :flag
end
