class MessagesController < ApplicationController
  before_filter :enforce_access

  def index
    # Lists messages (when, subject, to whom (team or all))
    @messages = current_user.messages.order(sent_at: :desc)
  end

  def show
    # Lists message info
    @message = current_user.messages.find_by_id(params[:id])
  end
end
