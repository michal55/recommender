module Recommend
  extend self
  def random
    # deal_items = DealItem.find(:all, order: "RANDOM()", limit: 5)
    deal_items = DealItem.order("RANDOM()").first(10)
    # puts "Random deals:"
    result = []
    deal_items.each do |d|
      result.push(d.deal_id)
      # puts "Item: #{d.id}   Deal: #{d.deal_id}"
    end
    result
  end

  def evaluate (user_id)
    TestActivity.where(user_id: user_id).order("RANDOM()").first
  end

  def most_popular
    top = Activity.group(:deal_id).count.sort_by{|k,v| v}.reverse
    top[0...10].map{|k,v| k}
    # TestActivity.select("deal_id, count(*) as total_count").group("deal_id").order("total_count").reverse_order
  end

  def test_random(user_count)
    time_start = Time.now
    stats = Stat.new
    stats.hits = 0
    stats.total = 0
    stats.strategy = 'random'
    users = TestActivity.order("RANDOM()").limit(user_count).pluck(:user_id)
    users.each do |user|
      recommended = random
      deal = evaluate(user).deal_id
      stats.total += 1
      stats.hits += 1 if recommended.include?(deal)

      # puts "R: #{recommended}  T: #{deal}"
    end
    stats.save
    puts Time.now - time_start
  end

  def test_content(user_count)
    time_start = Time.now
    stats = Stat.new
    stats.hits = 0
    stats.total = 0
    stats.strategy = 'most_popular'
    users = TestActivity.order("RANDOM()").limit(user_count).pluck(:user_id)
    recommended = most_popular
    users.each do |user|
      stats.total += 1
      stats.hits += 1 if recommended.include?(evaluate(user).deal_id)
    end
    stats.save
    puts Time.now - time_start
  end


end
