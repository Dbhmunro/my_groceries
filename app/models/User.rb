class User < ActiveRecord::Base
    has_many :shopping_lists
    has_many :groceries, through: :shopping_lists

    has_secure_password

    validates_presence_of :username, :email

    #explore self joins for families if enough time
end