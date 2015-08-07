class Integrity < ActiveRecord::Base
  belongs_to :user
  # Maybe use attakc or defend here, since there can be multiple per round?
  belongs_to :round
end
