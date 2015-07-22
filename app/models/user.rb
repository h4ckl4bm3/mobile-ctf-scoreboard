class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :messages
  has_many :availabilities
  has_many :integrities
  has_many :hacks
  has_many :flags # contains all flags over each round
  has_many :flag_submissions # contains both their submissions and the other teams
end
