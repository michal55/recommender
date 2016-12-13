module Test
  extend self
  @most_popular = Recommend.most_popular 400
  @test_deals = TestDetail.all.pluck(:deal_id)

  def recommend_top
    top = Activity.where(deal_id: @test_deals).group(:deal_id).count.sort_by{|k,v| v}.reverse
    top[0...10].map{|k,v| k}
  end

  @recommend_top = recommend_top

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

  def faves user_id
    deals = []
    deals += Activity.where(user_id: user_id, deal_id: @most_popular ).group(:deal_id).count.sort_by{|k,v| v}.reverse.map{|k,v| k}
  end

  def not_popular_faves user_id
    deals = []
    deals += Activity.where(user_id: user_id).where.not(deal_id: @most_popular ).group(:deal_id).count.sort_by{|k,v| v}
  end

  def not_faves(count, user)
    # opakujuce sa nepopularne nakupy - aspon dva krat kupeny deal a musi predstavovat aspon 5% vsetkych jeho dealov
    arr = not_popular_faves(user).reverse.map { |k, v| k if v/count.to_f > 0.05 and v > 1 }
    result = []
    arr.each do |a|
      result.push(a) unless a.nil?
    end
    result
  end

  def user_deals user_id
    deals = []
    deals += Activity.where(user_id: user_id).pluck(:deal_id)
  end

  def test_content(user_count, mode)
    time_start = Time.now
    stats = Stat.new
    stats.hits = 0
    stats.total = 0
    stats.eval = 'p@k'
    stats.strategy = 'faves most_popular' if mode == 1
    stats.strategy = 'faves most_popular significant not_popular' if mode == 2
    users = TestActivity.order("RANDOM()").limit(user_count).pluck(:user_id)
    users.each do |user|
      recommended = recommend_faves(user) if mode == 1
      recommended = recommend(user) if mode == 2
      stats.total += 1
      stats.hits += 1 if recommended.include?(evaluate(user).deal_id)
    end
    stats.save
    puts Time.now - time_start
  end

  def test_precision(user_count, mode)
    time_start = Time.now

    stats = Stat.new
    stats.strategy = 'faves most_popular' if mode == 1
    stats.strategy = 'faves most_popular significant not_popular' if mode == 2
    stats.strategy = 'most_popular' if mode == 3
    stats.strategy = 'random' if mode == 4
    stats.eval = 'precision'
    stats.hits = 0
    stats.total = 0

    users = TestActivity.order("RANDOM()").limit(user_count).pluck(:user_id).uniq
    users.each do |user_id|
      user_buys = TestActivity.where(user_id: user_id).pluck(:deal_id)
      recommended = recommend_faves(user_id) if mode == 1
      recommended = recommend(user_id) if mode == 2
      recommended = @recommend_top if mode == 3
      recommended = random if mode == 4
      stats.total += 1
      stats.hits += 1 if (user_buys&recommended).size > 0
    end

    stats.save
    puts Time.now - time_start

  end

  def recommend user
    count = user_deals(user).size
    fav_buys = faves(user)
    not_fav_buys = not_faves(count, user)
    f_size = fav_buys.size
    n_size = not_fav_buys.size

    result = []
    result = @most_popular[0...10] if count == 0

    # if count >= 10
      if fav_buys.size >= 5 # at least 5 popular deals bought
        result = fav_buys[0...5]  # 5 user's fav and popular deals
        if n_size > 0
          result.push(not_fav_buys[0])
          result += @most_popular[0...4]
        else
        result += (@most_popular[0...5])
        end
      else
        result += fav_buys
        if n_size < 4
          result += not_fav_buys
        else
          result += not_fav_buys[0..4]
        end
        result += @most_popular[0...10-result.size]
      end
    # else
      # 3 most popular, N faves, M podobne
    # end
    result

  end

  def recommend_faves user
    count = user_deals(user).size
    fav_buys = faves(user)
    result = []
    result = @most_popular[0...10] if count == 0
    if fav_buys.size >= 5 # at least 5 popular deals bought
      result = fav_buys[0...5]  # 5 user's fav and popular deals
      result += (@most_popular[0...5])
    else
      result += fav_buys
      result += @most_popular[0...10-result.size]
    end

  end

end