class ShoppingList < ActiveRecord::Base
    belongs_to :user
    has_many :groceries

    validates :name, presence: true, allow_blank: false
end