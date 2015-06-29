class FlagSubmission < ActiveRecord::Base
  belongs_to :team
  belongs_to :owner, class: :team
  belongs_to :round
end
