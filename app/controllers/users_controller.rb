class UsersController < ApplicationController
  def index
    @teams = User.all
  end

  def show
  end

  def update
  end

  def create
  end
end
