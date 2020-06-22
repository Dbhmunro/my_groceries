class Grocery < ActiveRecord::Base
    belongs_to :shopping_list

    validates :name, presence: true, allow_blank: false
    validates :quantity, presence: true, allow_blank: false
end