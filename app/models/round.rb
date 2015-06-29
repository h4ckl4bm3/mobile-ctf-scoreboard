class Round < ActiveRecord::Base
  has_many :availabilities
  has_many :integrities
  has_many :hacks
  has_many :flags
  has_many :flag_submissions
end
