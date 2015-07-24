class Player < User

  has_many :messages
  has_many :integrities
  has_many :flags # contains all flags over each round
  has_many :flag_submissions # contains both their submissions and the other teams
end
