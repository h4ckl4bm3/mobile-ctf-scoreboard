class RoundsController < ApplicationController

  respond_to :json

  def current_time
    # round = Round.instance
    # raise ActiveRecord::RecordNotFound unless round
    now = Time.now # This will eventually be used for Rounds
    countdown_to_end = AttackPeriod.find_by('start <= :now and :now <= finish', {now: now})
    countdown_to_end = DefendPeriod.find_by('start <= :now and :now <= finish', {now: now}) unless countdown_to_end
    # two periods should not overlap at the same time, but future roudns could
    unless countdown_to_end
      countdown_to_start_attack = AttackPeriod.find_by('start > :now', {now: now})
      countdown_to_start_defend = DefendPeriod.find_by('start > :now', {now: now})
      countdown_to_start = if countdown_to_start_defend and countdown_to_start_attack
        (countdown_to_start_defend.start - now) < (countdown_to_start_attack.start - now) ? countdown_to_start_defend : countdown_to_start_attack
      else
        countdown_to_start_attack ? countdown_to_start_attack : countdown_to_start_defend
      end
    end
    time = nil
    attack = nil
    if countdown_to_end
      attack = countdown_to_end.is_a?(AttackPeriod) ? true : false
      time = countdown_to_end.finish
    elsif countdown_to_start
      attack = countdown_to_start.is_a?(AttackPeriod) ? true : false
      time = countdown_to_start.start
    end
    respond_with do |format|
      format.json { render json: MultiJson.encode(time: time, countdown_to_end: countdown_to_end.nil? ? false : true, attack: attack) }
    end
  end
end
