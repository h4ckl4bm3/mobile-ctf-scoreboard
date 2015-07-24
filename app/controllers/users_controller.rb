class UsersController < ApplicationController
  def index
    @teams = Player.all
  end

  def show
  end
end
