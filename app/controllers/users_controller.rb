class UsersController < ApplicationController

  def index
    @teams = Player.all
    @title = "Teams"
  end

  def show
    @player = Player.find(params[:id])
    @players = [@player]

    # @flags_submitted = to_timeline FlagSubmission.where("user_id=?",params[:id]).group_by {|sf| sf.updated_at.change(:sec=>0)}
    @score = @player.score
    @title = @player.display_name

    render :show
  end
end
