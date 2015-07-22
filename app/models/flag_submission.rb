class FlagSubmission < ActiveRecord::Base
  belongs_to :user
  belongs_to :owner, class_name: "User", foreign_key: 'owner_id'
  belongs_to :round
end
