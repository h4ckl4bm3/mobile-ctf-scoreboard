class UsersController < ApplicationController

  def index
    @teams = Player.all
  end

  def show
    @player = Player.find(params[:id])
    @players = [@player]

    # @solved_challenges = @player.solved_challenges.order("created_at DESC")
    # @flags_submitted = to_timeline FlagSubmission.where("user_id=?",params[:id]).group_by {|sf| sf.updated_at.change(:sec=>0)}
    # @achievements = @player.achievements.order("created_at DESC")
    # @adjustments = @player.score_adjustments.order("created_at DESC")
    # @score = @player.score
    @title = @player.display_name
    # @subtitle = %[#{pluralize(@score, "point")} and #{pluralize(@achievements.count, "achievement")}]
    
      render :show
  end
end
