class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include SessionsHelper
  include ActionView::Helpers::TextHelper

  before_filter :load_period, :load_messages_count

  def enable_auto_reload
    @auto_reload = false
  end

  def load_period
    # @round = Round.instance
    # raise ActiveRecord::RecordNotFound unless @round
    unless current_user.nil?
      now = Time.now # This will eventually be used for Rounds
      @period = AttackPeriod.find_by('start <= :now and :now <= finish', {now: now})
      @period = DefendPeriod.find_by('start <= :now and :now <= finish', {now: now}) unless @period
    end
  end

  def load_messages_count
    unless current_user.nil?
      @messages_count = current_user.messages.count
    end
  end

  def enforce_access
    deny_access unless current_user
  end
end
