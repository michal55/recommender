class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
    	t.integer :user_id
    	t.integer :quantity
    	t.float   :market_price
    	t.integer :create_time
    	t.integer :deal_id
    	t.references :deal_item
      t.timestamps null: false
    end
  end
end
