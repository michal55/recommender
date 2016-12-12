module Recommend
  extend self
  @test_deals = TestDetail.all.pluck(:deal_id)
  def random
    deal_items = TestDealItem.order("RANDOM()").first(10)
    result = []
    deal_items.each do |d|
      result.push(d.deal_id)
    end
    result
  end

  def evaluate (user_id)
    TestActivity.where(user_id: user_id).order("RANDOM()").first
  end

  def most_popular n
    top = Activity.where(deal_id: @test_deals).group(:deal_id).count.sort_by{|k,v| v}.reverse
    top[0...n].map{|k,v| k}
    # TestActivity.select("deal_id, count(*) as total_count").group("deal_id").order("total_count").reverse_order
  end

  def recommend mode
    if mode.eql?('random')
      random
    elsif mode.eql?('most_popular')
      most_popular 10
    end
  end

  def test_content(user_count, mode)
    time_start = Time.now
    stats = Stat.new
    stats.hits = 0
    stats.total = 0
    stats.strategy = mode
    users = TestActivity.order("RANDOM()").limit(user_count).pluck(:user_id)
    recommended = recommend(mode)
    users.each do |user|
      stats.total += 1
      stats.hits += 1 if recommended.include?(evaluate(user).deal_id)
    end
    stats.save
    puts Time.now - time_start
  end

end
