class CreateTestDetails < ActiveRecord::Migration
  def change
    create_table :test_details do |t|
      t.string :title_deal
      t.string :title_desc
      t.string :title_city
      t.integer :deal_id
      t.integer :partner_id
      t.float	:gpslat
      t.float :gpslong
      t.integer :deal_item_id
      t.timestamps null: false
    end
  end
end
