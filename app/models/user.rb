class User < ApplicationRecord
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :lockable, :validatable
end
