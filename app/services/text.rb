module Text
  extend self
  def seed_keywords user_id
    deal_ids = Activity.where(user_id: user_id).pluck(:deal_id)
    deals = Detail.where(deal_id: deal_ids).pluck(:title_deal)
    merged = ""
    deals.each do |title|
      merged += bash(process(title))
    end
    top_keywords = []
    keywords = merged.keywords(Highscore::Content)
    keywords.rank[0...10].each do |k|
      top_keywords.push(k.text)
    end
    top_keywords
  end

  def deal_keywords
    # title = Detail.find(detail_id).title_deal
    deals = TestDetail.all
    puts deals.size
    deals.each do |d|
      merged = bash(process(d.title_deal))
      merged += merged
      merged += bash(process(d.title_desc))
      # d.keywords =
      merged.keywords(Highscore::Content).rank[0..10].each do |k|
        d.keywords.push(k.text)
      end
      d.save
    end
  end


  def bash(sentence)
    `echo "#{sentence}" | stemmsk light`
  end

  def process(sentence)
    @stop_words ||= Stop.all.pluck(:word)
    I18n.transliterate(sentence).downcase.delete('^a-z ').split.delete_if{|x| @stop_words.include?(x)}.join(' ')
  end

  def user
    # @test_deals ||= TestDetail.all.pluck(:deal_id)
    Activity.where.not(user_id: User.all.pluck(:id)).group(:user_id).count.sort_by{|k,v| v}
  end

  def top_users
    # @test_deals ||= TestDetail.all.pluck(:deal_id)
    users = User.all.pluck(:id)
    time = Time.now
    top = Activity.where.not(user_id: users).group(:user_id).count.sort_by{|k,v| v}.reverse[0...40000].map{|k,v| k}
    top.each do |user_id|
      next if users.include?(user_id)
      user = User.new
      user.id = user_id
      user.keywords = seed_keywords user_id
      user.save
    end
    puts Time.now - time
  end

  def similar user_id, n
    @test_details ||= TestDetail.all
    user = User.find(user_id)
    hash = Hash.new
    @test_details.each do |td|
      hash[td.deal_id] = (td.keywords&user.keywords).size
    end
    result = []
    hash.sort_by{|k,v| v}.reverse[0...n].map{|k,v| k if v > 1}.each{|h| result.push(h) unless h.nil?}
    result
  end


  # def stopwords
  #   f = File.open("/home/michal/workspace/ruby/recommender/recommender/lib/seeds/stop1.txt", "r")
  #     f.each_line do |t|
  #       w = Stop.new
  #       w.word = I18n.transliterate(t[0...-1])
  #       w.save
  #   end
  # end



end