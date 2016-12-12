require 'net/http'
module Train
  extend self
  @stop_words = Stop.all.pluck(:word)

  def basic user_id
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

  def deal_keywords detail_id
    title = Detail.find(detail_id).title_deal
    title.split(' ').each do |word|
      puts word
    end

  end

  def bash(sentence)
    `echo "#{sentence}" | stemmsk light`
  end

  def process(sentence)
    I18n.transliterate(sentence).downcase.delete('^a-z ').split.delete_if{|x| @stop_words.include?(x)}.join(' ')
  end

  def top_users
    time = Time.now
    top = Activity.group(:user_id).count.sort_by{|k,v| v}.reverse[0...2000].map{|k,v| k}
    top.each do |user_id|
      user = User.new
      user.id = user_id
      user.keywords = basic user_id
      user.save
    end
    puts Time.now - time
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

# 523801