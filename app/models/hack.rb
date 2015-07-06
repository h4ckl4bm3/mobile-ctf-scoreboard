class Hack < ActiveRecord::Base
  belongs_to :team
  belongs_to :target, class_name: "Team"
  belongs_to :round
  has_one :availability # only exists if successful
end
