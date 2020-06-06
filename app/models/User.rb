class User < ActiveRecord::Base
    has_many :shopping_lists
    has_many :groceries, through: :shopping_lists

    has_secure_password

    #explore self joins for families if enough time
end