class TeamsController < ApplicationController
  def create
  end

  def show
  end

  def index
    @teams = Team.all
  end

  def update
  end
end
