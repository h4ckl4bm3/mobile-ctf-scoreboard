class Round < ActiveRecord::Base
  has_many :integrities
  has_many :flags
  has_many :flag_submissions
  has_many :attack_period
  has_many :defend_period
end
