class Round < ActiveRecord::Base
  has_many :integrities
  has_many :flags
  has_many :flag_submissions
end
