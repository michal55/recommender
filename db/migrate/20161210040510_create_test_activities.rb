class CreateTestActivities < ActiveRecord::Migration
  def change
    create_table :test_activities do |t|
      t.integer :user_id
      t.integer :quantity
      t.float   :market_price
      t.integer :create_time
      t.integer :deal_id
      t.references :deal_item
      t.float :team_price
      t.timestamps null: false
    end
  end
end
