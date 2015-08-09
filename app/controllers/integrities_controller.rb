class IntegritiesController < ApplicationController
  before_filter :enforce_access
  
  def index
    # Lists integreties (when, on what commit, success)
    @integrities = current_user.integrities
  end

  def show
    # Lists integreties (when, on what commit, success, link to code?) may not be necessary
  end
end
