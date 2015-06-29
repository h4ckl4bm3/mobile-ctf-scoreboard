class Integrity < ActiveRecord::Base
  belongs_to :team
  belongs_to :round
end
