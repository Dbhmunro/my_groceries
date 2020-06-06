class CreateGroceries < ActiveRecord::Migration
  def change
    create_table :groceries do |t|
      t.string :name
      t.integer :quantity
      t.integer :shopping_list_id
    end
  end
end
