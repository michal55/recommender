module Test
  extend self
  @most_popular = Baseline.most_popular 400
  @test_deals = TestDetail.all.pluck(:deal_id)
  @N = 10 #number of deals recommended
  @users_with_keywords = User.all.pluck(:id)

  def recommend_top
    top = Activity.where(deal_id: @test_deals).group(:deal_id).count.sort_by{|k,v| v}.reverse
    top[0...@N].map{|k,v| k}
  end
  @recommend_top = recommend_top

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


  def activity_precision(user_count, mode)
    @users_with_keywords ||= User.all.pluck(:id)
    time_start = Time.now
    stats = Stat.new
    stats.hits = 0
    stats.total = 0
    stats.eval = 'p@a'
    stats.num_rec = @N
    stats.strategy = 'combination' if mode == 0
    stats.strategy = 'faves most_popular' if mode == 1
    stats.strategy = 'faves most_popular significant not_popular' if mode == 2
    stats.strategy = 'similar' if mode == 5
    users = TestActivity.order("RANDOM()").limit(user_count).pluck(:user_id)

    users.each do |user|
      recommended = recommend_faves(user) if mode == 1
      recommended = recommend(user) if mode == 2
      if mode == 5 and @users_with_keywords.include?(user)
        recommended = Text.similar(user, @N)
      elsif mode == 5
        next
      end
      recommended = combination(user) if mode == 0

      stats.total += 1
      stats.hits += 1 if recommended.include?(evaluate(user).deal_id)
    end
    stats.save
    puts Time.now - time_start
  end

  def user_precision(user_count, mode)
    @users_with_keywords ||= User.all.pluck(:id)
    time_start = Time.now

    stats = Stat.new
    stats.strategy = 'combination' if mode == 0
    stats.strategy = 'faves most_popular' if mode == 1
    stats.strategy = 'faves most_popular significant not_popular' if mode == 2
    stats.strategy = 'most_popular' if mode == 3
    stats.strategy = 'random' if mode == 4
    stats.strategy = 'similar' if mode == 5
    stats.eval = 'p@u'
    stats.hits = 0
    stats.total = 0
    stats.num_rec = @N
    users = TestActivity.order("RANDOM()").limit(user_count).pluck(:user_id).uniq

    users.each do |user_id|
      user_buys = TestActivity.where(user_id: user_id).pluck(:deal_id)
      recommended = recommend_faves(user_id) if mode == 1
      recommended = recommend(user_id) if mode == 2
      recommended = @recommend_top if mode == 3
      recommended = random if mode == 4
      if mode == 5 and @users_with_keywords.include?(user_id)
        recommended = Text.similar(user_id, @N)
      elsif mode == 5
        next
      end

      recommended = combination(user_id) if mode == 0

      stats.total += 1
      stats.hits += 1 if (user_buys&recommended).size > 0
    end

    stats.save
    puts Time.now - time_start

  end

  def combination user
    if @users_with_keywords.include?(user) # similar deals for those who have keywords calculated
      result = similar(user)
      rest = recommend(user)
      (0...rest.size).each{|i| result.push(rest[i]) if i%2==0 and result.size < @N}
      result += @most_popular[0...@N-result.size]
      return result
    end
    recommend(user)
  end

  def similar(user)
    fav_buys = faves(user)
    result = []
    result += Text.similar(user, @N)[0...-1]
    result += fav_buys[0...@N-result.size]
    result += @most_popular[0...@N-result.size]
  end

  def recommend user
    count = user_deals(user).size
    fav_buys = faves(user)
    not_fav_buys = not_faves(count, user)
    f_size = fav_buys.size
    n_size = not_fav_buys.size
    result = []

    return @most_popular[0...@N] if count == 0

    if f_size >= 5 # at least 5 popular deals bought
      result = fav_buys[0...(@N/2)]  # half of user's fav and popular deals
      if n_size > 0
        result.push(not_fav_buys[0])  #50% fav deals, one not_fav deal is enough
        result += @most_popular[0...@N-result.size]
      else
      result += @most_popular[0...@N-result.size]
      end

    else
      result += fav_buys
      if n_size <= @N/5
        result += not_fav_buys
      else
        result += not_fav_buys[0..@N/5]
      end
      result += @most_popular[0...@N-result.size]
    end

    result

  end

  def recommend_faves user
    count = user_deals(user).size
    fav_buys = faves(user)
    result = []
    result = @most_popular[0...@N] if count == 0
    if fav_buys.size >= 5 # at least 5 popular deals bought
      result = fav_buys[0...7]  # 5 user's fav and popular deals
      result += (@most_popular[0...@N-result.size])
    else
      result += fav_buys
      result += @most_popular[0...@N-result.size]
    end
    result

  end

end