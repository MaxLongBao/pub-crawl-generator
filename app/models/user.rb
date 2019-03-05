class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :crawls

  # validates :user_name, uniqueness: true, presence: true
  validates :email, uniqueness: true, presence: true
  validates :password, presence: true
end
