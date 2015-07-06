class FlagSubmission < ActiveRecord::Base
  belongs_to :team
  belongs_to :owner, class_name: "Team", foreign_key: 'owner_id'
  belongs_to :round
end
