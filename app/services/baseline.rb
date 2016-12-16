module Baseline
  extend self
  @N = 15
  def random
    deal_items = TestDealItem.order("RANDOM()").first(@N)
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
    @test_deals ||= TestDetail.all.pluck(:deal_id)
    top = Activity.where(deal_id: @test_deals).group(:deal_id).count.sort_by{|k,v| v}.reverse
    top[0...n].map{|k,v| k}
    # TestActivity.select("deal_id, count(*) as total_count").group("deal_id").order("total_count").reverse_order
  end

  def recommend mode
    if mode.eql?('random')
      random
    elsif mode.eql?('most_popular')
      most_popular @N
    end
  end

  def test_baseline(user_count, mode)
    time_start = Time.now
    stats = Stat.new
    stats.hits = 0
    stats.total = 0
    stats.eval = 'p@a'
    stats.num_rec = @N
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
