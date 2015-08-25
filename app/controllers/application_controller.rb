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
    now = Time.now # This will eventually be used for Rounds
    @countdown_to_end = AttackPeriod.find_by('start <= :now and :now <= finish', {now: now})
    @countdown_to_end = DefendPeriod.find_by('start <= :now and :now <= finish', {now: now}) unless @countdown_to_end
    # two periods should not overlap at the same time, but future roudns could
    unless @countdown_to_end
      countdown_to_start_attack = AttackPeriod.find_by('start > :now', {now: now})
      countdown_to_start_defend = DefendPeriod.find_by('start > :now', {now: now})
      @countdown_to_start = if countdown_to_start_defend and countdown_to_start_attack
        (countdown_to_start_defend.start - now) < (countdown_to_start_attack.start - now) ? countdown_to_start_defend : countdown_to_start_attack
      else
        countdown_to_start_attack ? countdown_to_start_attack : countdown_to_start_defend
      end
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
