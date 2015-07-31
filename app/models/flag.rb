class Flag < ActiveRecord::Base
  belongs_to :user
  belongs_to :round
  has_one :attack_period
end
