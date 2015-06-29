class Availability < ActiveRecord::Base
  belongs_to :team
  belongs_to :round
  belongs_to :hack # only exists if successful
end
