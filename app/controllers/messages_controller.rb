class MessagesController < ApplicationController
  before_filter :enforce_access
  
  def index
    # Lists messages (when, subject, to whom (team or all))
  end

  def show
    # Lists message info
  end
end
