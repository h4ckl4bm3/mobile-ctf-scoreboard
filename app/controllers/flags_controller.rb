class FlagsController < ApplicationController
  before_filter :enforce_access

  def index
    # Shows flags by Round? Along with how many points are currently held/lost 
  end

  def show
    # Shows current flag? along with how many points are currently held/lost (should at least show this)
  end
end
