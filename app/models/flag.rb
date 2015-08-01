class Flag < ActiveRecord::Base
  belongs_to :user
  belongs_to :round
  belongs_to :attack_period
end
