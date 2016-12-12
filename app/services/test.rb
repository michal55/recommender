module Test
  extend self
  @most_popular = Recommend.most_popular 400
  def user user_id
    # keywords = User.find(user_id).keywords
    # test_user = TestActivity.where(user_id: user_id).order("RANDOM()").first


  end

  def faves user_id # doplnit, co ked kupuje to iste co ale neni fav?
    deals = Activity.where(user_id: user_id, deal_id: @most_popular[5...-1] ).group(:deal_id).count.sort_by{|k,v| v}.reverse.map{|k,v| k}
    # puts deals
    # deals.size
  end

  def user_deals user_id
    Activity.where(user_id: user_id).pluck('DISTINCT deal_id')
  end

  def test_content(user_count)
    time_start = Time.now
    stats = Stat.new
    stats.hits = 0
    stats.total = 0
    stats.strategy = 'faves most_popular'
    users = TestActivity.order("RANDOM()").limit(user_count).pluck(:user_id)
    users.each do |user|
      recommended = recommend(user)
      stats.total += 1
      stats.hits += 1 if recommended.include?(Recommend.evaluate(user).deal_id)
    end
    stats.save
    puts Time.now - time_start
  end


  # 5 faves, 5 recommended if more than 5 buys
      #
  # else 5 faves, 10-N recommended
  def recommend user
    count = user_deals user
    deals = faves(user)
    restult = []
    # if count >= 10
      if deals.size >= 5 # at least 5 popular deals bought
        result = deals[0...5]  # 5 user's fav and popular deals
        result += (@most_popular[0...5])
      else
        result = deals[0...deals.size]
        result += (@most_popular[0...(10-deals.size)])
      end
    result

    # end
  end
end