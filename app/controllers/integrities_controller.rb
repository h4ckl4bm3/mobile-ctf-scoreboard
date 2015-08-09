class IntegritiesController < ApplicationController
  before_filter :enforce_access

  def index
    # Lists integreties (when, on what commit, success)
    @integrities = current_user.integrities
    @title = "Integrities"
  end
end
