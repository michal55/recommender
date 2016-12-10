class AddDealItemToDetail < ActiveRecord::Migration
  def change
  	add_reference :details, :deal_item
  end
end
