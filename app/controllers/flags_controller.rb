class FlagsController < ApplicationController
  before_filter :enforce_access

  def index
    # Shows flags along with how many points are currently held/lost
    # ordering by creation will likely be accurate enough 
    @flags = current_user.flags.order(created_at: :desc)
  end

  def show
    # Shows more details on the flag?
  end
end
