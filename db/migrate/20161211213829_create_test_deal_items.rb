class CreateTestDealItems < ActiveRecord::Migration
  def change
    create_table :test_deal_items do |t|
      t.integer :deal_id
      t.string  :title_dealitem
      t.string  :coupon_text1
      t.string  :coupon_text2
      t.string  :coupon_begin_time
      t.string  :coupon_end_time
      t.timestamps null: false
    end
  end
end
