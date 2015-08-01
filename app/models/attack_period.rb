class AttackPeriod < ActiveRecord::Base
  belongs_to :round
  has_many :flags
end
