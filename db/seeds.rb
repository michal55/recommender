require 'csv'
# csv_text = File.read(Rails.root.join('lib','seeds','train_dealitems.csv'))
# csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
# csv.each do |row|
# 	d = DealItem.new
# 	d.id = row['id']
# 	d.deal_id = row['deal_id']
# 	d.title_dealitem = row['title_dealitem']
# 	d.coupon_text1 = row['coupon_text1']
# 	d.coupon_text2 = row['coupon_text2']
# 	d.coupon_begin_time = row['coupon_begin_time']
# 	d.coupon_end_time = row['coupon_end_time']
# 	d.save
# end

# csv_text = File.read(Rails.root.join('lib','seeds','train_activity_v2.csv'))
# csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
# csv.each do |row|
# 	a = Activity.new
# 	a.id = row['id']
# 	a.user_id = row['user_id']
# 	a.deal_item_id = row['dealitem_id']
# 	a.deal_id = row['deal_id']
# 	a.quantity = row['quantity']
# 	a.market_price = row['market_price']
# 	a.create_time = row['create_time']
# 	a.save
# end
#
csv_text = File.read(Rails.root.join('lib','seeds','test_activity_v2.csv'))
csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
csv.each do |row|
	a = TestActivity.new
	a.id = row['id']
	a.user_id = row['user_id']
	a.deal_item_id = row['dealitem_id']
	a.deal_id = row['deal_id']
	a.quantity = row['quantity']
	a.market_price = row['market_price']
	a.create_time = row['create_time']
	a.save
end

# csv_text = File.read(Rails.root.join('lib','seeds','train_deal_details.csv'))
# csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
# csv.each do |row|
# 	d = Detail.new
# 	d.deal_item_id = row['id']
# 	d.title_deal = row['title_deal']
# 	d.title_desc = row['title_desc']
# 	d.title_city = row['title_city']
# 	d.deal_id = row['deal_id']
# 	d.partner_id = row['partner_id']
# 	d.gpslat = row['gpslat']
# 	d.gpslong = row['gpslong']
# 	d.save
# end
#
# csv_text = File.read(Rails.root.join('lib','seeds','train_activity_v2.csv'))
# csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
# csv.each do |row|
# 	a = Activity.find(row['id'])
#   a.team_price = row['team_price']
# 	a.save
# end